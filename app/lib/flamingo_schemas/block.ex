defmodule FlamingoSchemas.Block do
  @moduledoc """
  """

  use FlamingoSchemas.Base

  @type t :: %__MODULE__{
          id: id() | nil,
          label: String.t() | nil,
          name: String.t() | nil,
          type: atom() | nil,
          value: String.t() | nil
        }

  embedded_schema do
    field :label
    field :name
    field :type, Ecto.Enum, values: [:text, :richtext, :boolean, :integer, :reference]
    field :value
  end
end
