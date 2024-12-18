defmodule FlamingoSchemas.Collection do
  @moduledoc """
  """

  use FlamingoSchemas.Base

  @type t :: %__MODULE__{
          id: id() | nil,
          name: String.t() | nil,
          description: String.t() | nil,
          handle: String.t() | nil,
          template: String.t() | nil,
          blocks: Ecto.Schema.embeds_many(FlamingoSchemas.Block.t()),
          pages: Ecto.Schema.has_many(FlamingoSchemas.Page.t()),
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "collections" do
    field :name
    field :description
    field :handle
    field :template

    embeds_many :blocks, FlamingoSchemas.Block, on_replace: :delete

    has_many :pages, FlamingoSchemas.Page

    timestamps(type: :utc_datetime_usec)
  end
end
