defmodule UserInterface.FetchSessionToken do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    session_token = get_session_token(conn)

    # Implement your logic to fetch user session data based on the session token
    user_session_data = fetch_user_session_data(session_token)

    assign(conn, :user_session_data, user_session_data)
  end

  defp get_session_token(conn) do
    # Implement logic to extract session token from the request (e.g., from a request header or query parameter)
    # Example: get_session(conn)["session_token"]
  end

  defp fetch_user_session_data(session_token) do
    # Implement logic to fetch user session data from the database based on the session token
    # Example: UserSession.find_by(session_token: session_token)
  end
end
