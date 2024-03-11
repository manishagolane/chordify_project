defmodule UserInterface.PageController do
  use UserInterface, :controller
  import Phoenix.LiveView.Controller

  require Logger

  alias Streamer.CommonAccess

  def index(conn, _params) do
    render(conn, "index.html",error_message: "")
  end

  def login(conn, %{"user" => user_params}) do
    Logger.debug("login... #{inspect(user_params)}")

    %{"phone_number" => phone_number, "password" => password} = user_params

    case CommonAccess.get_user_phone_number(String.to_integer(phone_number)) do
      {:ok, users} ->
        user = hd(users)
        IO.inspect(user.password,label: "user password")
        if password == user.password do
          products = CommonAccess.show_products()

          # conn
          # |> put_session(:user_id, user.uid)
          # |> put_session(:session_id, session_id)
          # |> put_session("user_secret", %{"uid" => user.uid})
          # |> put_status(302)

          conn
            |> put_session("user_secret", %{"uid" => user.uid})
            |> put_status(302)
            |>
            live_render(UserInterface.PageLive,
              session: %{"current_uid" => user.uid,"current_uname" => user.name,"products" => products, "cart" => user.cart}
            )
        else
          render(conn, "index.html", error_message: "wrong password")
        end

      {:error, _} ->
        conn
        # |> put_flash(:error, "Invalid phone number")
        |> put_status(401)
        |> render("index.html", error_message: "Invalid phone number or password")
    end
  end
end
