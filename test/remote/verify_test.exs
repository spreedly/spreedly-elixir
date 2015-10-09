defmodule Remote.VerifyTest do
  @moduletag [:remote]
  use ExUnit.Case, async: true

  alias Spreedly.Environment

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
    assert trans.payment_method.first_name == "Ivan"
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

  defp create_test_card do
    card_deets = %{number: "4111111111111111", month: 1, year: 2019, last_name: "Drago", first_name: "Ivan"}
    { :ok, transaction } = Environment.add_credit_card(env, card_deets)
    transaction.payment_method
  end

end
