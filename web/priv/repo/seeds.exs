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
alias Portfolio.Wallets.Wallet

%User{}
|> User.registration_changeset(%{
  email: "t0hashvein@gmail.com",
  password: "G00dP@ssw0rd"
})
|> Portfolio.Repo.insert!()

%Wallet{}
|> Wallet.changeset(%{
  id: 1,
  name: "Binance",
  type: 2
})
|> Portfolio.Repo.insert!()

%Wallet{}
|> Wallet.changeset(%{
  id: 2,
  name: "Spot",
  type: 2,
  parent_id: 1
})
|> Portfolio.Repo.insert!()

%Wallet{}
|> Wallet.changeset(%{
  id: 3,
  name: "Earn",
  type: 2,
  parent_id: 1
})
|> Portfolio.Repo.insert!()
