defmodule Remote.ShowReceiverTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, reason } = Spreedly.show_receiver(bogus_env, "SomeToken")
    assert reason =~ "Unable to authenticate"
  end

  test "non existent receiver" do
    { :error, reason } = Spreedly.show_receiver(env(), "NonExistentToken")
    assert reason =~ "Unable to find the specified receiver"
  end

  test "show receiver" do
    token = create_test_receiver().token
    {:ok, receiver } = Spreedly.show_receiver(env(), token)
    assert receiver.receiver_type == "test"
    assert receiver.token == token
  end
end
