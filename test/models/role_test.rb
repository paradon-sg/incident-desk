require "test_helper"

class RoleTest < ActiveSupport::TestCase
  test "customer and agent are allowed role names" do
    %w[ customer agent ].each do |name|
      assert Role.new(name: name).valid?
    end
  end

  test "unsupported and missing role names are rejected" do
    [ "admin", "", nil ].each do |name|
      role = Role.new(name: name)

      assert_not role.save
      assert_includes role.errors[:name], "is not included in the list"
    end
  end
end
