defmodule FlamingoWeb.CollectionLive do
  use Phoenix.LiveView
  import Phoenix.HTML

  alias Flamingo.Collections
  alias FlamingoWeb.CoreComponents

  def mount(_params, _session, socket) do
    changeset = Collections.change_collection(%Collections.Collection{})
    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("validate", %{"collection" => collection_params}, socket) do
    changeset =
      %Collections.Collection{}
      |> Collections.change_collection(collection_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"collection" => collection_params}, socket) do
    case Collections.create_collection(collection_params) do
      {:ok, _collection} ->
        {:noreply, socket |> put_flash(:info, "Collection created successfully.") |> push_redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
