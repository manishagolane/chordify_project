defmodule Streamer.Product.ProductRepo do
  alias Streamer.Product.Products

  def create_product(%Products{} = products) do
    Memento.transaction!(fn ->
      Memento.Query.write(products)
    end)
  end

  def show_products do
    Memento.transaction!(fn ->
      Memento.Query.all(Products)
    end)
  end

  def get_product(id) do
    Memento.transaction!(fn->
      Memento.Query.read(Products, id)
    end)
  end

  def update(id, %{} = changes) do
    Memento.transaction(fn ->
      case Memento.Query.read(Products, id, lock: :write) do
        %Products{} = product ->
          product
          |> struct(changes)
          |> Memento.Query.write()
          |> then(&{:ok, &1})

        nil ->
          {:error, :not_found}
      end
    end)
  end

end
