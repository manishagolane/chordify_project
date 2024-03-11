defmodule Streamer.User.UserRepo do
  alias Streamer.User.Users

  def create_user(%Users{} = users) do
    Memento.transaction!(fn ->
      Memento.Query.write(users)
    end)
  end

  def show_users do
    Memento.transaction!(fn ->
      Memento.Query.all(Users)
    end)
  end

  @spec get_uid(any()) :: any()
  def get_uid(uid) do
    Memento.transaction!(fn->
      Memento.Query.read(Users, uid)
    end)
  end

  def get_user_phone_number(phone_number) do
    guard = {:==, :phone_number, phone_number}

    data = Memento.transaction!(fn ->
        Memento.Query.select(Users,guard)
    end)
    if (length(data) == 0) do
      {:error,""}
    else
      {:ok, data}
    end
  end

  def delete_user(uid) do
    Memento.transaction!(fn ->
      Memento.Query.delete(Users, uid)
    end)
  end


  def update(id, %{} = changes) do
    Memento.transaction(fn ->
      case Memento.Query.read(Users, id, lock: :write) do
        %Users{} = user ->
          user
          |> struct(changes)
          |> Memento.Query.write()
          |> then(&{:ok, &1})

        nil ->
          {:error, :not_found}
      end
    end)
  end

end
