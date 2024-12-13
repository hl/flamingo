defmodule Flamingo.Pages do
  @moduledoc """
  This module contains functions for working with pages.
  """

  alias Flamingo.Infra.Repo
  alias FlamingoSchemas.Page
  alias FlamingoSchemas.Collection

  import Ecto.Changeset
  import Ecto.Query

  @type block :: %{
          label: String.t() | nil,
          name: String.t() | nil,
          type: atom() | nil,
          value: String.t() | nil
        }

  @type attrs :: %{
          handle: String.t(),
          blocks: [block() | FlamingoSchemas.Block.t()]
        }

  @doc """
  Fetches all pages.
  """
  @spec all_pages(Collection.id()) :: [Page.t()]
  def all_pages(collection_id) do
    query = from(p in Page, where: p.collection_id == ^collection_id)
    Repo.all(query)
  end

  @doc """
  Fetches a page by ID.
  """
  @spec get_page!(id :: Page.id()) :: Page.t()
  def get_page!(id) do
    Repo.get!(Page, id)
  end

  @doc """
  Fetches a page by handle.
  """
  @spec get_page_by_handle!(handle :: String.t()) :: Page.t() | nil
  def get_page_by_handle!(handle) do
    Repo.get_by!(Page, handle: handle)
  end

  @doc """
  Creates a Page.
  """
  @spec create_page(attrs :: attrs()) ::
          {:ok, Page.t()} | {:error, Ecto.Changeset.t(Page.t())}
  def create_page(attrs) do
    store_page(%Page{}, attrs)
  end

  @doc """
  Updates a Page.
  """
  @spec update_page(page :: Page.t(), attrs :: attrs()) ::
          {:ok, Page.t()} | {:error, Ecto.Changeset.t(Page.t())}
  def update_page(page, attrs) do
    store_page(page, attrs)
  end

  @doc """
  Deletes a Page.
  """
  @spec delete_page(page :: Page.t()) :: {:ok, Page.t()}
  def delete_page(page) do
    Repo.delete(page)
  end

  @spec store_page(page :: Page.t(), attrs :: attrs()) ::
          {:ok, Page.t()} | {:error, Ecto.Changeset.t(Page.t())}
  def store_page(page, attrs) do
    changeset = change_page(page, attrs)
    Repo.insert_or_update(changeset)
  end

  @spec change_page(Page.t(), attrs :: map()) ::
          Ecto.Changeset.t(Page.t())
  def change_page(page, attrs) do
    page
    |> cast(attrs, [:handle])
    |> cast_embed(:blocks,
      with: &change_block/2,
      sort_param: :block_sort,
      drop_param: :block_drop
    )
    |> update_change(:handle, &Slug.slugify/1)
    |> unsafe_validate_unique([:handle], Repo)
    |> unique_constraint(:handle)
    |> validate_required([:handle])
  end

  @spec change_block(block :: FlamingoSchemas.Block.t(), attrs :: block()) ::
          Ecto.Changeset.t(FlamingoSchemas.Block.t())
  def change_block(block, attrs) do
    block
    |> cast(attrs, [:label, :name, :type, :value])
    |> validate_required([:label, :name, :type, :value])
  end
end
