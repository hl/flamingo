defmodule FlamingoSchemas.Base do
  @moduledoc """
  Base schema module.
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @type id :: non_neg_integer()
    end
  end
end
