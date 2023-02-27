defmodule Portfolio.EctoHelpers do
  import Ecto.Query, warn: false

  def period_query(q, "week") do
    dow =
      Date.utc_today()
      |> Date.day_of_week()

    where(q, [p], fragment("date_part('dow', ?)", p.date) == ^dow)
  end

  def period_query(q, "month"), do:
    where(q, [p], fragment("date_part('day', ?)", p.date) == ^Date.utc_today.day)

  def period_query(q, "year"), do:
    where(q, [p], fragment("date_part('day', ?)", p.date) == ^Date.utc_today.day and fragment("date_part('month', ?)", p.date) == ^Date.utc_today().month)

  def period_query(q, _period), do: q

end
