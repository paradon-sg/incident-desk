class CreateSessions < ActiveRecord::Migration[8.1]
  # Create user sessions with request metadata and an enforced user reference.
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end
end
