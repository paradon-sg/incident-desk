class RolifyCreateRoles < ActiveRecord::Migration[8.1]
  # Create roles and a join table that permits at most one role per user.
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.references :resource, polymorphic: true

      t.timestamps
    end

    create_table :users_roles, id: false do |t|
      # Unique: one role per user (requirements §2). Rolify's add_role writes this
      # join row directly, skipping User validations, so the database enforces it.
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.references :role, null: false, foreign_key: true
    end

    add_index :roles, :name
    add_index :roles, [ :name, :resource_type, :resource_id ]
  end
end
