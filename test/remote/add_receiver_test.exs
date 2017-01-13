defmodule Remote.AddReceiverTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, reason } = Environment.add_receiver(bogus_env, :test)
    assert reason =~ "Unable to authenticate"
  end

  test "non existent receiver type" do
    { :error, reason } = Environment.add_receiver(env(), :nonexistent_type)
    assert reason == "The specified receiver_type is not supported"
  end

  test "paid account required" do
    { :error, reason } = Environment.add_receiver(env(), :sabre)
    assert reason =~ "has not been activated for real transactions"
  end

  test "add test receiver" do
    {:ok, receiver } = Environment.add_receiver(env(), :test, hostnames: "http://posttestserver.com")

    assert "test" == receiver.receiver_type
    assert "retained" == receiver.state
    assert "test" == receiver.receiver_type
    assert receiver.token
  end

end
