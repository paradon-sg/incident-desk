namespace :users do
  desc "Create a user: bin/rails users:create EMAIL=you@example.com ROLE=customer|agent " \
       "(prompts for the password, or reads it from PASSWORD)"
  task create: :environment do
    require "io/console"

    email_address = ENV["EMAIL"].presence || abort("EMAIL is required, e.g. EMAIL=you@example.com")
    role = ENV["ROLE"].presence || abort("ROLE is required, one of: #{User::ROLES.join(", ")}")

    password = ENV["PASSWORD"].presence || begin
      abort "PASSWORD is required when not running in a terminal" unless $stdin.tty?
      print "Password: "
      $stdin.noecho(&:gets).to_s.chomp.tap { puts }
    end

    user = User.new(email_address: email_address, password: password, role: role)

    if user.save
      puts "Created #{user.role} #{user.email_address}"
    else
      abort "Could not create user: #{user.errors.full_messages.to_sentence}"
    end
  end
end
