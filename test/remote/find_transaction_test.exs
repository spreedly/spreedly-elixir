defmodule Remote.FindTransactionTest do
  @moduletag [:remote]
  use ExUnit.Case, async: true
  alias Spreedly.Environment
  alias Spreedly.Transaction.Verification

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, message } = Environment.find_transaction(bogus_env, "SomeToken")
    assert message =~ "Unable to authenticate"
  end

  test "non existent transaction" do
    { :error, message } = Environment.find_transaction(env, "NonExistentToken")
    assert message =~ "Unable to find the transaction"
  end

  test "find verify transaction" do
    {:ok, %Verification{token: token} } = Environment.verify(env, create_test_gateway.token, create_test_card.token)
    {:ok, trans } = Environment.find_transaction(env, token)
    assert trans.payment_method.last_name == "Drago"
    assert trans.on_test_gateway == true
    assert trans.__struct__ == Spreedly.Transaction.Verification
  end

  test "find add payment method transaction" do
    token = create_test_card_transaction.token
    {:ok, trans } = Environment.find_transaction(env, token)
    assert trans.transaction_type == "AddPaymentMethod"
    assert trans.__struct__ == Spreedly.Transaction.AddPaymentMethod
  end

  defp env do
    Environment.new(Application.get_env(:spreedly, :environment_key), Application.get_env(:spreedly, :access_secret))
  end

  defp create_test_gateway do
    { :ok, gateway } = Environment.add_gateway(env, :test)
    gateway
  end

  defp create_test_card do
    create_test_card_transaction.payment_method
  end

  defp create_test_card_transaction do
    card_deets = %{number: "4111111111111111", month: 1, year: 2019, last_name: "Drago", first_name: "Ivan"}
    { :ok, transaction } = Environment.add_credit_card(env, card_deets)
    transaction
  end
end
