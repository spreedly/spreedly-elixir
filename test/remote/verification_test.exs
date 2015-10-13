defmodule Remote.VerificationTest do
  use Remote.EnvironmentCase

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, reason } = Environment.verify(bogus_env, "gateway_token", "payment_method_token")
    assert reason =~ "Unable to authenticate"
  end

  test "payment method not found" do
    { :error, reason } = Environment.verify(env, create_test_gateway.token, "unknown_card")
    assert reason =~ "There is no payment method"
  end

  test "gateway not found" do
    { :error, reason } = Environment.verify(env, "unknown_gateway", create_test_card.token)
    assert reason == "Unable to find the specified gateway."
  end

  test "successful verify" do
    {:ok, trans } = Environment.verify(env, create_test_gateway.token, create_test_card.token)
    assert trans.succeeded == true
    assert trans.payment_method.first_name == "Matrim"
  end

  @tag skip: "Not implemented yet"
  test "failed verify" do
  end

end
