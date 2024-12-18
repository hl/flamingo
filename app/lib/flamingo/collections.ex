defmodule Flamingo.Collections do
  @moduledoc """
  This module contains functions for working with collections.
  """

  alias Flamingo.Infra.Repo
  alias FlamingoSchemas.Collection

  import Ecto.Changeset

  @type block :: %{
          label: String.t() | nil,
          name: String.t() | nil,
          type: atom() | nil
        }

  @type attrs :: %{
          name: String.t(),
          description: String.t(),
          handle: String.t(),
          blocks: [block() | FlamingoSchemas.Block.t()]
        }

  @doc """
  Fetches all collections.
  """
  @spec all_collections() :: [Collection.t()]
  def all_collections do
    Repo.all(Collection)
  end

  @doc """
  Fetches a collection by ID.
  """
  @spec get_collection!(id :: Collection.id()) :: Collection.t()
  def get_collection!(id) do
    Repo.get!(Collection, id)
  end

  @doc """
  Creates a Collection.
  """
  @spec create_collection(attrs :: attrs()) ::
          {:ok, Collection.t()} | {:error, Ecto.Changeset.t(Collection.t())}
  def create_collection(attrs) do
    store_collection(%Collection{}, attrs)
  end

  @doc """
  Updates a Collection.
  """
  @spec update_collection(collection :: Collection.t(), attrs :: attrs()) ::
          {:ok, Collection.t()} | {:error, Ecto.Changeset.t(Collection.t())}
  def update_collection(collection, attrs) do
    store_collection(collection, attrs)
  end

  @doc """
  Deletes a Collection.
  """
  @spec delete_collection(collection :: Collection.t()) :: {:ok, Collection.t()}
  def delete_collection(collection) do
    Repo.delete(collection)
  end

  @spec store_collection(collection :: Collection.t(), attrs :: attrs()) ::
          {:ok, Collection.t()} | {:error, Ecto.Changeset.t(Collection.t())}
  def store_collection(collection, attrs) do
    changeset = change_collection(collection, attrs)
    Repo.insert_or_update(changeset)
  end

  @spec change_collection(Collection.t(), attrs :: map()) ::
          Ecto.Changeset.t(Collection.t())
  def change_collection(collection, attrs) do
    collection
    |> cast(attrs, [:name, :description, :handle])
    |> cast_embed(:blocks,
      with: &change_block/2,
      sort_param: :block_sort,
      drop_param: :block_drop
    )
    |> unsafe_validate_unique([:name, :handle], Repo)
    |> unique_constraint(:name)
    |> unique_constraint(:handle)
    |> validate_required([:name, :handle])
  end

  @spec change_block(block :: FlamingoSchemas.Block.t(), attrs :: block()) ::
          Ecto.Changeset.t(FlamingoSchemas.Block.t())
  def change_block(block, attrs) do
    block
    |> cast(attrs, [:label, :name, :type])
    |> validate_required([:label, :name, :type])
  end
end
