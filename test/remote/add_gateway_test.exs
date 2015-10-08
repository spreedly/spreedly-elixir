defmodule Remote.AddGatewayTest do
  @moduletag [:remote]
  use ExUnit.Case, async: true

  alias Spreedly.Environment

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, reason } = Environment.add_gateway(bogus_env, :test)
    assert reason =~ "Unable to authenticate"
  end

  test "non existent gateway type" do
    { :error, reason } = Environment.add_gateway(env, :nonexistent_type)
    assert reason == "The gateway_type parameter is invalid."
  end

  test "paid account required" do
    { :error, reason } = Environment.add_gateway(env, :sage)
    assert reason =~ "has not been activated for real transactions"
  end

  test "add test gateway" do
    {:ok, gateway } = Environment.add_gateway(env, :test)

    assert "test" == gateway.gateway_type
    assert "retained" == gateway.state
    assert "Spreedly Test" == gateway.name
    assert gateway.token
  end

  defp env do
    Environment.new(Application.get_env(:spreedly, :environment_key), Application.get_env(:spreedly, :access_secret))
  end

end
