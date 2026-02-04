# frozen_string_literal: true

class User < ApplicationRecord
  # Include devise modules for API authentication
  # - database_authenticatable: Handles password encryption
  # - registerable: Allows user registration
  # - recoverable: Password reset via email
  # - trackable: Track sign in count, timestamps and IP
  # - validatable: Email/password validations
  # - jwt_authenticatable: JWT token authentication (devise-jwt)
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
end
