defmodule Remote.ListCreatedGatewaysTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    {:error, reason} = Spreedly.list_created_gateways(bogus_env)
    assert reason =~ "Unable to authenticate"
  end

  test "list created gateways sorted" do
    {:ok, gateway_1} = Spreedly.add_gateway(env(), :test)
    :timer.sleep(1000)
    {:ok, gateway_2} = Spreedly.add_gateway(env(), :test)
    :timer.sleep(1000)
    {:ok, list} = Spreedly.list_created_gateways(env(), order: :desc)

    assert returned_gateway_1 = Enum.find(list, fn g -> g.token == gateway_1.token end)
    assert returned_gateway_2 = Enum.find(list, fn g -> g.token == gateway_2.token end)
    assert returned_gateway_1.created_at < returned_gateway_2.created_at
  end
end
