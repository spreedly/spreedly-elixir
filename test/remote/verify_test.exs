defmodule Remote.VerifyTest do
  @moduletag [:remote]
  use ExUnit.Case, async: true

  alias Spreedly.Environment

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, reason } = Spreedly.Environment.verify(bogus_env, "gateway_token", "payment_method_token")
    assert reason =~ "Unable to authenticate"
  end

  test "payment method not found" do
    { :error, reason } = Spreedly.Environment.verify(env, create_test_gateway.token, "unknown_card")
    assert reason =~ "There is no payment method"
  end

  test "gateway not found" do
  end

  test "successful verify" do
  end

  test "failed verify" do
  end

  defp env do
    Environment.new(Application.get_env(:spreedly, :environment_key), Application.get_env(:spreedly, :access_secret))
  end

  defp create_test_gateway do
    { :ok, gateway } = Environment.add_gateway(env, :test)
    gateway
  end

end
