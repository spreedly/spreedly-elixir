defmodule Remote.ListPaymentMethodTransactionsTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, reason } = Environment.list_payment_method_transactions(bogus_env, "SomeToken")
    assert reason =~ "Unable to authenticate"
  end

  test "non existent payment method" do
    { :error, reason } = Environment.list_payment_method_transactions(env, "NonExistentToken")
    assert reason =~ "Unable to find the specified payment method"
  end

  test "list transactions" do
    card = create_test_card
    gateway = create_test_gateway
    {:ok, trans_1} = Environment.verify(env, gateway.token, card.token)
    {:ok, trans_2} = Environment.purchase(env, gateway.token, card.token, 100)

    {:ok, list} = Environment.list_payment_method_transactions(env, card.token)
    assert length(list) == 3
    assert Enum.at(list, 1).token == trans_1.token
    assert Enum.at(list, 2).token == trans_2.token
  end

  test "list transactions sorted" do
    card = create_test_card
    gateway = create_test_gateway
    {:ok, trans_1} = Environment.verify(env, gateway.token, card.token)
    {:ok, trans_2} = Environment.purchase(env, gateway.token, card.token, 100)

    {:ok, list} = Environment.list_payment_method_transactions(env, card.token, order: :desc)
    assert length(list) == 3
    assert Enum.at(list, 0).token == trans_2.token
    assert Enum.at(list, 1).token == trans_1.token
  end

end
