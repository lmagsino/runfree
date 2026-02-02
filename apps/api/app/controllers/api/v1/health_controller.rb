# frozen_string_literal: true

module Api
  module V1
    class HealthController < BaseController
      # GET /api/v1/health
      def show
        render json: {
          status: "ok",
          timestamp: Time.current.iso8601,
          version: "1.0.0",
          services: {
            database: database_status,
            redis: redis_status
          }
        }
      end

      private

      def database_status
        ActiveRecord::Base.connection.execute("SELECT 1")
        "connected"
      rescue StandardError
        "disconnected"
      end

      def redis_status
        REDIS.ping == "PONG" ? "connected" : "disconnected"
      rescue StandardError
        "disconnected"
      end
    end
  end
end
