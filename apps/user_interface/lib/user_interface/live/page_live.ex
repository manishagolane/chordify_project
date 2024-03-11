defmodule UserInterface.PageLive do
  # use UserInterface, :live_view
  use Phoenix.LiveView

  require Logger

  @internal_database_topic "database:info"

  @impl true
  def mount(_params, session, socket) do
    current_uid = Map.get(session, "current_uid")
    products = Map.get(session, "products")
    current_uname = Map.get(session,"current_uname")
    IO.inspect(current_uid,label: "current_uid")
    IO.inspect(products,label: "products")
    cart = Map.get(session, "cart")
    Phoenix.PubSub.subscribe(UserInterface.PubSub, "send_message")
    Phoenix.PubSub.subscribe(UserInterface.PubSub, "get_updated_product")

    {:ok, assign(socket,
    current_uid: current_uid,
    products: products,
    cart: cart,
    selected_product: nil,
    message: "",
    current_uname: current_uname
    )}
  end

  @impl true
  def handle_info({:send_message, message}, socket) do
    IO.inspect("send_message....")

    if socket.assigns.current_uid == message.current_uid do
      IO.inspect(message)
      socket =
       assign(socket,
       message: message.message,
      )
      {:noreply, socket}
    else
     {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:get_updated_product, data}, socket) do
    IO.inspect("get_updated_product....")
    IO.inspect(data)

    if socket.assigns.current_uid == data.uid do
      socket =
        assign(socket,
        products: data.products,
        cart: data.cart
        )
      {:noreply, socket}
    else
      socket =
        assign(socket,
        products: data.products
        )
     {:noreply, socket}
    end
  end


  # @impl true
  # def render(assigns) do
  #   ~L"""
  #     <%= render("page_live.html", assigns) %>
  #   """
  # end

  def delete_cart(u_id, product_id) do
    Phoenix.PubSub.broadcast(
      UserInterface.PubSub,
      @internal_database_topic,
      {:delete_cart,
       %{
        product_id: product_id,
         u_id: u_id
       }}
    )
    Phoenix.PubSub.subscribe(UserInterface.PubSub, "get_updated_product")
  end

  @impl true
  def handle_event("del-cart", %{"select_product" => select_product}, socket) do
    IO.inspect(select_product,label: "del-cart")

    delete_cart(socket.assigns.current_uid, String.to_integer(select_product))
    socket =
      assign(socket,
        selected_product: String.to_integer(select_product),
        message: ""
      )

    {:noreply, socket}
  end

  def add_cart(u_id, product_id) do
    Phoenix.PubSub.broadcast(
      UserInterface.PubSub,
      @internal_database_topic,
      {:add_cart,
       %{
        product_id: product_id,
         u_id: u_id
       }}
    )
    Phoenix.PubSub.subscribe(UserInterface.PubSub, "get_updated_product")
  end

  @impl true
  def handle_event("add-cart", %{"select_product" => select_product}, socket) do
    IO.inspect(select_product,label: "add-cart")
    add_cart(socket.assigns.current_uid, String.to_integer(select_product))
    socket =
      assign(socket,
        selected_product: String.to_integer(select_product),
        message: ""
      )

    {:noreply, socket}
  end

end
