class User < ApplicationRecord
  rolify
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
  validate :has_exactly_one_role

  def role
    roles.first&.name
  end

  private
    def has_exactly_one_role
      errors.add(:roles, "must be exactly one of #{Role::NAMES.to_sentence(two_words_connector: " or ", last_word_connector: ", or ")}") unless roles.size == 1
    end
end
