defmodule Remote.AddGatewayTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, reason } = Spreedly.add_gateway(bogus_env, :test)
    assert reason =~ "Unable to authenticate"
  end

  test "non existent gateway type" do
    { :error, reason } = Spreedly.add_gateway(env(), :nonexistent_type)
    assert reason == "The gateway_type parameter is invalid."
  end

  test "paid account required" do
    { :error, reason } = Spreedly.add_gateway(env(), :sage)
    assert reason =~ "has not been activated for real transactions"
  end

  test "add test gateway" do
    {:ok, gateway } = Spreedly.add_gateway(env(), :test)

    assert "test" == gateway.gateway_type
    assert "retained" == gateway.state
    assert "Spreedly Test" == gateway.name
    assert gateway.token
  end

end
