defmodule Streamer.CommonAccess do
  alias Streamer.User.{UserRepo, Users}
  alias Streamer.Product.{ProductRepo, Products}

  require Logger
  @user_repo UserRepo
  @product_repo ProductRepo


    def get_all_users do
      @user_repo.show_users()
    end

    def get_uid(id) do
      @user_repo.get_uid(id)
    end

    def create_user(data) do
      res =
        %Users{}
        |> struct(
          data
        )
        |> @user_repo.create_user

      user_id  = Map.fetch!(res, :phone_number )
      {:ok, user_id }
    end

    def get_user_phone_number(phone_number) do
      {status, user} = @user_repo.get_user_phone_number(phone_number)
      {status, user}
    end

    def delete_user(user_id ) do
      @user_repo.delete_user(user_id )
    end

    def update_user(user_id , %{} = changes) do
      Logger.debug("#{__MODULE__}: Updating #{inspect(user_id )}")
      Logger.debug("#{__MODULE__}: #{inspect(changes)}")

      {:ok, data}  = @user_repo.update(user_id , changes)
    end

    def show_products do
      @product_repo.show_products()
    end

    def get_product(id) do
      @product_repo.get_product(id)
    end

    def create_product(data) do
      res =
        %Products{}
        |> struct(
          data
        )
        |> @product_repo.create_product

      product_id  = Map.fetch!(res, :id )
      {:ok, product_id }
    end

    def update_product(id , %{} = changes) do
      Logger.debug("#{__MODULE__}: Updating #{inspect(id )}")
      Logger.debug("#{__MODULE__}: #{inspect(changes)}")

      {:ok, data}  = @product_repo.update(id , changes)
    end


  end
