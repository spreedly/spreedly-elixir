defmodule Remote.AddCreditCardTest do
  @moduletag [:remote]
  use ExUnit.Case, async: true

  alias Spreedly.Environment

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, message } = Environment.add_credit_card(bogus_env, card_deets)
    assert message =~ "Unable to authenticate"
  end

  test "failed with validation error" do
    { :error, reason } = Environment.add_credit_card(env, card_deets(first_name: "  ", last_name: nil))
    assert reason =~ "First name can't be blank\nLast name can't be blank"
  end

  test "paid account required" do
    { :error, reason } = Environment.add_credit_card(env, card_deets(number: "44421"))
    assert reason =~ "has not been activated for real transactions"
  end

  test "successfully add" do
    {:ok, trans } = Environment.add_credit_card(env, card_deets)
    assert trans.payment_method.first_name == "Matrim"
    assert trans.message == "Succeeded!"
    assert trans.payment_method.number == "XXXX-XXXX-XXXX-4444"
    assert trans.payment_method.token
    assert trans.token
    assert trans.payment_method.token != trans.token
    assert "cached" == trans.payment_method.storage_state
  end

  test "retain on create" do
  end

  test "add using full name" do
  end

  defp env do
    Environment.new(Application.get_env(:spreedly, :environment_key), Application.get_env(:spreedly, :access_secret))
  end

  defp card_deets(options \\ []) do
    default_deets = %{
      email: "matrim@wot.com", number: "5555555555554444", month: 1, year: 2019,
      last_name: "Cauthon", first_name: "Matrim"
    }
    Dict.merge(default_deets, options)
  end

end
