defmodule FlamingoSchemas.Page do
  @moduledoc """
  """

  use FlamingoSchemas.Base

  @type t :: %__MODULE__{
          id: id() | nil,
          handle: String.t() | nil,
          blocks: Ecto.Schema.embeds_many(FlamingoSchemas.Block.t()),
          collection: Ecto.Schema.belongs_to(FlamingoSchemas.Collection.t()),
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "pages" do
    field :handle

    embeds_many :blocks, FlamingoSchemas.Block, on_replace: :delete

    belongs_to :collection, FlamingoSchemas.Collection

    timestamps(type: :utc_datetime_usec)
  end
end
