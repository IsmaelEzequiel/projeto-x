defmodule WealthWave.Repo do
  use Ecto.Repo,
    otp_app: :wealth_wave,
    adapter: Ecto.Adapters.Postgres
end
