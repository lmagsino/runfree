# frozen_string_literal: true

Rails.application.routes.draw do
  # Rails default health check (used by load balancers)
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    namespace :v1 do
      # Health check with service status
      resource :health, only: [:show], controller: "health"

      # Future routes will be added here:
      # - Authentication (Phase 1.A.8-10)
      # - Users/Profiles (Phase 1.A.11-14)
      # - Training Plans (Phase 1.A.15-17)
      # - Workouts (Phase 1.A.18)
    end
  end
end
