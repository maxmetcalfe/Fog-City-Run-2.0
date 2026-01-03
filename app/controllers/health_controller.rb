class HealthController < ApplicationController
  def show
    racer = Racer.first!
    render json: { status: "ok", racer_id: racer.id }, status: :ok
  rescue StandardError => e
    render json: { status: "error", error: e.message }, status: :internal_server_error
  end
end
