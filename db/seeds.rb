# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Development users, one per role. Set SEED_PASSWORD to choose their password;
# otherwise a random one is generated and printed, so no credential lives in the repo.
seed_password = ENV["SEED_PASSWORD"].presence || SecureRandom.base58(16)

{ "customer@example.com" => "customer", "agent@example.com" => "agent" }.each do |email_address, role|
  User.find_or_create_by!(email_address: email_address) do |user|
    user.password = seed_password
    user.add_role role
    puts "Seeded #{role} #{email_address} (password: #{ENV["SEED_PASSWORD"].present? ? "from SEED_PASSWORD" : seed_password})"
  end
end
