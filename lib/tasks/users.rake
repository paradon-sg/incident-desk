namespace :users do
  desc "Create a user. Usage: bin/rails users:create EMAIL=you@example.com ROLE=customer|agent " \
       "(password from the PASSWORD env var, otherwise a hidden prompt)"
  task create: :environment do
    email_address = ENV["EMAIL"].presence or abort "EMAIL is required."
    role = ENV["ROLE"].to_s
    abort "Invalid role #{role.inspect}. ROLE must be one of: #{Role::NAMES.join(", ")}." unless Role::NAMES.include?(role)

    password = ENV["PASSWORD"].presence || begin
      require "io/console"
      $stdout.print "Password: "
      line = $stdin.tty? ? $stdin.noecho(&:gets).tap { $stdout.puts } : $stdin.gets
      line.to_s.chomp
    end

    user = User.new(email_address: email_address, password: password)
    user.add_role role

    if user.save
      puts "Created #{role} #{user.email_address}."
    else
      abort "Could not create user: #{user.errors.full_messages.to_sentence}."
    end
  end
end
