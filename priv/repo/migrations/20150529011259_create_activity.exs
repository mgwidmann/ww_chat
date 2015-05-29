defmodule WwChat.Repo.Migrations.CreateActivity do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :user, :string
      add :message, :string

      timestamps
    end

  end
end
