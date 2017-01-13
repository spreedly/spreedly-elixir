defmodule Remote.ShowGatewayTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, reason } = Environment.show_gateway(bogus_env, "SomeToken")
    assert reason =~ "Unable to authenticate"
  end

  test "non existent gateway" do
    { :error, reason } = Environment.show_gateway(env(), "NonExistentToken")
    assert reason =~ "Unable to find the specified gateway"
  end

  test "show gateway" do
    token = create_test_gateway().token
    {:ok, gateway } = Environment.show_gateway(env(), token)
    assert gateway.gateway_type == "test"
    assert gateway.name == "Spreedly Test"
    assert gateway.token == token
  end
end
