defmodule Streamer.ResetAllDatabase do

  def reset_all_database() do
    :mnesia.delete_table(Streamer.User.Users)
    :mnesia.delete_table(Streamer.Product.Products)

    Streamer.Mnesia.setup!(Streamer.User.Users)
    Streamer.Mnesia.setup!(Streamer.Product.Products)

    reset_users()
    reset_products()

  end

  def reset_users() do
    u1 = %{
      name: "user 1",
      phone_number: 9000090000,
      password: "abc",
      email: "user1@gmail.com",
      cart: 0
    }
    u2 = %{
      name: "user 2",
      phone_number: 8000080000,
      password: "xyz",
      email: "user2@gmail.com",
      cart: 0
    }

    Streamer.CommonAccess.create_user(u1)
    Streamer.CommonAccess.create_user(u2)

    IO.puts("created  users")
  end

  def reset_products() do
    p1 = %{
      name: "Product 1",
      price: 10.0,
      quantity_available: 5
    }
    p2 = %{
      name: "Product 2",
      price: 10.0,
      quantity_available: 3
    }
    p3 = %{
      name: "Product 3",
      price: 10.0,
      quantity_available: 5
  }
    p4 = %{
      name: "Product 4",
      price: 10.0,
      quantity_available: 10
    }
    p5 = %{
      name: "Product 5",
      price: 10.0,
      quantity_available: 2
    }


    Streamer.CommonAccess.create_product(p1)
    Streamer.CommonAccess.create_product(p2)
    Streamer.CommonAccess.create_product(p3)
    Streamer.CommonAccess.create_product(p4)
    Streamer.CommonAccess.create_product(p5)


    IO.puts("created  products")
  end

end
