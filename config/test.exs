import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :user_interface, UserInterface.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "5Np8bmCymAxu6krCGpRcxjh9gV8DHdZ3nYK4F+H5iqHYrNc2paiOplfTkcFKvqkw",
  server: false
