FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2026-02-04 18:43:15" }
  end
end
