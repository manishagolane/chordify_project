# CordifyUmbrella

**TODO: Add description**

Cordify Umbrella is a comprehensive umbrella application designed to handle both web interface functionalities and database access. This umbrella app consists of two main applications: a Phoenix web app named UserInterface and an Elixir app for database storage and access called streamer. Additionally,  streamer facilitates database access through a GenServer and handles requests from LiveView via PubSub mechanism.



Phoenix Web Application: UserInterface
The Phoenix web application within Cordify Umbrella is responsible for handling the user interface. It includes templates, routers, controllers, and LiveViews to provide a dynamic and interactive user experience.

Features
Templates for rendering HTML pages.
Routers to define application routes.
Controllers to handle requests and responses.
LiveViews for real-time updates without page reloads.

Start the Cordify Umbrella application.-> from the main directory run: iex -S mix phx.server
Access the Phoenix web interface through the provided routes.
Interact with the web interface to add and remove items from the cart.
Elixir Database Application
The Elixir database application within Cordify Umbrella provides functionalities for database storage and access. It interacts with the Mnesia database to store and retrieve data efficiently.

Features
Database storage using Mnesia.
Access functionalities for data manipulation.
Installation
No additional installation steps are required for the Elixir database application as it is part of the Cordify Umbrella structure.
It utilizes a GenServer to manage database access and handles add and delete cart requests from LiveView via PubSub mechanism.

Features
GenServer for managing database access.
PubSub mechanism for communication with LiveView.
Dummy data generation for testing purposes.

Run the following command to initialize the Mnesia database with dummy data:
Copy code
Streamer.ResetAllDatabase.reset_all_database 
Access the Streamer functionalities through the provided routes.
Use the provided functionalities to interact with the database and observe conditional error messages.