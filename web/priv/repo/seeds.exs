# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Portfolio.Repo.insert!(%Portfolio.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Portfolio.Accounts.User
%User{}
|> User.registration_changeset(%{
  email: "t0hashvein@gmail.com",
  password: "G00dP@ssw0rd"
})
|> Portfolio.Repo.insert!()
