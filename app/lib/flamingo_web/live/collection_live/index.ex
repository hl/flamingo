defmodule FlamingoWeb.CollectionLive.Index do
  use Phoenix.LiveView
  use FlamingoWeb

  alias Flamingo.Collections

  def mount(_params, _session, socket) do
    collections = Collections.all_collections()
    {:ok, assign(socket, :collections, collections)}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Collections
    </.header>
    <.table id="collections" rows={@collections}>
      <:col :let={collection} label="Name">
        <%= collection.name %>
      </:col>
      <:col :let={collection} label="Description">
        <%= collection.description %>
      </:col>
    </.table>
    """
  end
end
