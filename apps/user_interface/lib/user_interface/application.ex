defmodule UserInterface.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  @spec start(any(), any()) :: {:error, any()} | {:ok, pid()}
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      UserInterface.Telemetry,
      # Start the Endpoint (http/https)
      UserInterface.Endpoint,
      {Phoenix.PubSub, name: UserInterface.PubSub}
      # Start a worker by calling: UserInterface.Worker.start_link(arg)
      # {UserInterface.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UserInterface.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UserInterface.Endpoint.config_change(changed, removed)
    :ok
  end
end
