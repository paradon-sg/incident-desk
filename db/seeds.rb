# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Demo users for local development only. The password is a throwaway placeholder, not a real credential;
# set SEED_PASSWORD to use a different one. Create real users with `bin/rails users:create`.
if Rails.env.local?
  seed_password = ENV.fetch("SEED_PASSWORD", "password")

  { "customer@example.com" => "customer", "agent@example.com" => "agent" }.each do |email_address, role|
    User.find_or_create_by!(email_address: email_address) do |user|
      user.password = seed_password
      user.role = role
    end
  end
end
