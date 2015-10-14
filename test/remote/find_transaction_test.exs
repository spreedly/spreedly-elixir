defmodule Remote.FindTransactionTest do
  use Remote.EnvironmentCase

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
    {:ok, trans } = Environment.find_transaction(env, create_verify_transaction.token)
    assert trans.payment_method.last_name == "Cauthon"
    assert trans.on_test_gateway == true
    assert trans.__struct__ == Spreedly.Transaction.Verification
  end

  test "find add payment method transaction" do
    {:ok, trans } = Environment.find_transaction(env, create_test_card_transaction.token)
    assert trans.transaction_type == "AddPaymentMethod"
    assert trans.__struct__ == Spreedly.Transaction.AddPaymentMethod
  end

  defp create_test_card_transaction do
    { :ok, trans } = Environment.add_credit_card(env, card_deets)
    trans
  end

  defp create_verify_transaction do
    {:ok, trans } = Environment.verify(env, create_test_gateway.token, create_test_card.token)
    trans
  end
end
