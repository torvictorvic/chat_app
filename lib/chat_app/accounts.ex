defmodule ChatApp.Accounts do
  import Ecto.Query, warn: false
  alias ChatApp.Repo
  alias ChatApp.Accounts.User

  def get_or_create_user_by_name!(name) do
    Repo.get_by(User, name: name) ||
      Repo.insert!(User.changeset(%User{}, %{name: name}))
  end
end
