defmodule WwChat.Activity do
  use WwChat.Web, :model

  schema "activities" do
    field :user, :string
    field :message, :string

    timestamps
  end

  @required_fields ~w(user message)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
