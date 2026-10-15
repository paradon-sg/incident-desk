class User < ApplicationRecord
  rolify
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
  validate :has_exactly_one_role

  # Return the name of the user's single role for display in the top bar.
  def role
    roles.first&.name
  end

  private
    # Reject users whose role count differs from the required single role.
    def has_exactly_one_role
      errors.add(:roles, "must be exactly one of #{Role::NAMES.to_sentence(two_words_connector: " or ", last_word_connector: ", or ")}") unless roles.size == 1
    end
end
