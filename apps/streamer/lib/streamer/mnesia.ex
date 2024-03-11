defmodule Streamer.Mnesia do
  @tables [Streamer.User.Users,Stramer.Product.Products]

  def setup!(table, nodes \\ [node()]) do
    Memento.stop()
    Memento.Schema.create(nodes)
    Memento.start()

    Memento.Table.create!(table, disc_copies: nodes)
  end

  def init(tables \\ @tables) do
    Memento.stop()
    Memento.Schema.create([node()])
    Memento.start()

    Enum.each(tables, fn table ->
      Memento.Table.create(table, disc_copies: [node()])
    end)
  end

  def connect(tables \\ @tables) do
    Memento.start()
    Memento.add_nodes(Node.list())
    Memento.Schema.create([node()])
    Memento.Schema.set_storage_type(node(), :disc_copies)

    Enum.each(tables, fn table ->
      Memento.Table.create_copy(table, node(), :disc_copies)
    end)
  end

end
