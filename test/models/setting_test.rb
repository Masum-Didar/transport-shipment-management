require "test_helper"

class SettingTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:setting)
    assert record.valid?
  end

  test "required validations" do
    record = build(:setting, key: nil)
    assert_not record.valid?
    assert_includes record.errors[:key], "can't be blank"
  end

  test "uniqueness of key" do
    create(:setting, key: "site_name")
    record = build(:setting, key: "site_name")
    assert_not record.valid?
    assert_includes record.errors[:key], "has already been taken"
  end

  test "setting_type inclusion" do
    %w[string integer boolean json text].each do |t|
      assert build(:setting, setting_type: t).valid?, "#{t} should be valid"
    end
    record = build(:setting, setting_type: "invalid_type")
    assert_not record.valid?
    assert_includes record.errors[:setting_type], "is not included in the list"
  end

  test "scope by_group filters by group" do
    general = create(:setting, group: "general")
    create(:setting, group: "notification")
    assert_includes Setting.by_group("general"), general
    assert_equal 1, Setting.by_group("general").count
  end

  test "typed_value returns string as-is" do
    setting = create(:setting, setting_type: "string", value: "hello")
    assert_equal "hello", setting.typed_value
  end

  test "typed_value returns integer" do
    setting = create(:setting, setting_type: "integer", value: "42")
    assert_equal 42, setting.typed_value
  end

  test "typed_value returns boolean true" do
    setting = create(:setting, setting_type: "boolean", value: "true")
    assert_equal true, setting.typed_value
  end

  test "typed_value returns boolean false" do
    setting = create(:setting, setting_type: "boolean", value: "false")
    assert_equal false, setting.typed_value
  end

  test "typed_value parses json" do
    setting = create(:setting, setting_type: "json", value: '{"key": "value"}')
    assert_equal({"key" => "value"}, setting.typed_value)
  end

  test "typed_value returns text as-is" do
    setting = create(:setting, setting_type: "text", value: "long text")
    assert_equal "long text", setting.typed_value
  end
end
