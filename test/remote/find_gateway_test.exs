defmodule Remote.FindGatewayTest do
  use Remote.EnvironmentCase

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, message } = Environment.find_gateway(bogus_env, "SomeToken")
    assert message =~ "Unable to authenticate"
  end

  test "non existent gateway" do
    { :error, message } = Environment.find_gateway(env, "NonExistentToken")
    assert message =~ "Unable to find the specified gateway"
  end

  test "find gateway" do
    {:ok, gateway } = Environment.find_gateway(env, create_test_gateway.token)
    assert gateway.gateway_type == "test"
    assert gateway.name == "Spreedly Test"
    assert gateway.__struct__ == Spreedly.Gateway
  end
end
