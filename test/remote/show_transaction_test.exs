defmodule Remote.ShowTransactionTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    {:error, reason} = Spreedly.show_transaction(bogus_env, "SomeToken")
    assert reason =~ "Unable to authenticate"
  end

  test "non existent transaction" do
    {:error, reason} = Spreedly.show_transaction(env(), "NonExistentToken")
    assert reason =~ "Unable to find the transaction"
  end

  test "invalid token" do
    {:error, reason} = Spreedly.show_transaction(env(), "http://subdomain.spreedly.test")

    assert reason =~ "{\"status\":404,\"error\":\"Not Found\"}"
  end

  test "show verify transaction" do
    {:ok, trans} = Spreedly.show_transaction(env(), create_verify_transaction().token)
    assert trans.payment_method.last_name == "Cauthon"
    assert trans.transaction_type == "Verification"
  end

  test "show add payment method transaction" do
    {:ok, trans} = Spreedly.show_transaction(env(), create_test_card_transaction().token)
    assert trans.transaction_type == "AddPaymentMethod"
  end

  defp create_test_card_transaction do
    {:ok, trans} = Spreedly.add_credit_card(env(), card_deets())
    trans
  end
end
