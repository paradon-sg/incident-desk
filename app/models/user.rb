class User < ApplicationRecord
  ROLES = %w[ customer agent ].freeze

  rolify
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: ROLES, message: "must be one of: #{ROLES.join(", ")}" }

  after_save :assign_role, if: -> { @role }

  # Each user has exactly one role, stored through rolify.
  def role
    @role || roles.first&.name
  end

  def role=(name)
    @role = name.to_s
  end

  private
    def assign_role
      (roles.map(&:name) - [ @role ]).each { |name| remove_role(name) }
      add_role(@role)
      @role = nil
    end
end
