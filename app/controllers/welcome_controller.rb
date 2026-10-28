class WelcomeController < ApplicationController
  def index
    @next_race = with_db_retry { Race.where("date >= ?", Date.today).first }
  end

  private

  # The DB connection proxy (PlanetScale) can briefly fail to reach upstream
  # Postgres; retry once instead of 500-ing the homepage.
  def with_db_retry(retries: 1)
    yield
  rescue ActiveRecord::ConnectionNotEstablished, PG::ConnectionBad
    raise unless retries.positive?
    retries -= 1
    sleep 1
    retry
  end
end
