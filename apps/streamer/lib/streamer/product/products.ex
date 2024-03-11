defmodule Streamer.Product.Products do
  alias Memento

  use Memento.Table,
  attributes: [
    :id,
    :name,
    :price,
    :quantity_available
  ],
  type: :ordered_set,
  autoincrement: true

end
