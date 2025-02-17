defmodule Venieri.Repo do
  use Ecto.Repo,
    otp_app: :venieri,
    adapter: Ecto.Adapters.Postgres
end
