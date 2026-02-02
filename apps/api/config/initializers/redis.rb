# frozen_string_literal: true

# Redis configuration for RunFree API
# Used for caching and Sidekiq

REDIS_URL = ENV.fetch("REDIS_URL", "redis://localhost:6379/0")

REDIS = Redis.new(url: REDIS_URL)
