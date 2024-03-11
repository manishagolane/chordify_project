defmodule Streamer.User.Users do
  alias Memento

  use Memento.Table,
    attributes: [
    :uid,
    :phone_number,
    :name,
    :email,
    :password,
    :cart
  ],
  type: :ordered_set,
  autoincrement: true

end
