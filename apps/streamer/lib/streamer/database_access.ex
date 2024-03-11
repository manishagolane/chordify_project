defmodule Streamer.DatabaseAccess do
  use GenServer
  require Logger

  @internal_database_topic "database:info"
  alias Streamer.CommonAccess

  def start_link(config) do
    GenServer.start_link(
      __MODULE__,
      config,
      name: __MODULE__
    )
  end

  @impl true
  @spec init(any) :: {:ok, %{}}
  def init(_config) do
    #Logger.debug("#{__MODULE__}: GenServer init")
    Phoenix.PubSub.subscribe(UserInterface.PubSub, @internal_database_topic)
    {:ok, %{}}
  end


  # channel database:info callbacks
  @impl true
  def handle_info({event, payload}, state) do
    #Logger.debug("#{__MODULE__}: GenServer received #{inspect(event)}, #{inspect(payload)}")

    # for database_info event, the payload are the user_id, token number, symbol.
    case event do
      :add_cart ->
        handle_add_cart(payload, state)

      :delete_cart ->
        handle_delete_cart(payload, state)

    end

    {:noreply, state}
  end

  defp handle_add_cart(payload, state) do
    IO.inspect("handle_add_cart")
    IO.inspect(payload)
    products = CommonAccess.get_product(payload[:product_id])
    quantity_available = products.quantity_available - 1
    case quantity_available do
      x when x < 0 ->
        message = %{
          message: "Can't add to cart",
          current_uid: payload[:u_id]
        }
        Phoenix.PubSub.broadcast(
          UserInterface.PubSub,
          "send_message",
          {:send_message, message}
        )
      _ ->
        users = CommonAccess.get_uid(payload[:u_id])
        IO.inspect(users,lable: "users")
        cart = users.cart
        cart = cart + 1
        CommonAccess.update_user(payload[:u_id], %{cart: cart})
        CommonAccess.update_product(payload[:product_id], %{quantity_available: quantity_available})
        updated_products = CommonAccess.show_products()
        updated_user = CommonAccess.get_uid(payload[:u_id])

        data = %{
          products: updated_products,
          cart: updated_user.cart,
          uid: updated_user.uid
        }

      Phoenix.PubSub.broadcast(
        UserInterface.PubSub,
        "get_updated_product",
        {:get_updated_product, data}
      )
    end

    {:noreply, state}
  end

  defp handle_delete_cart(payload, state) do

    users = CommonAccess.get_uid(payload[:u_id])
    IO.inspect(users,lable: "users")
    cart = users.cart
    cart = cart - 1
    case cart do
      x when x < 0 ->
        message = %{
          message: "Not possible",
          current_uid: payload[:u_id]
        }
        Phoenix.PubSub.broadcast(
          UserInterface.PubSub,
          "send_message",
          {:send_message, message}
        )
      _ ->

        products = CommonAccess.get_product(payload[:product_id])
        quantity_available = products.quantity_available + 1
        CommonAccess.update_user(payload[:u_id], %{cart: cart})
        CommonAccess.update_product(payload[:product_id], %{quantity_available: quantity_available})
        updated_products = CommonAccess.show_products()
        updated_user = CommonAccess.get_uid(payload[:u_id])

        data = %{
          products: updated_products,
          cart: updated_user.cart,
          uid: updated_user.uid

        }

      Phoenix.PubSub.broadcast(
        UserInterface.PubSub,
        "get_updated_product",
        {:get_updated_product, data}
      )
    end

    {:noreply, state}
  end


end
