defmodule Remote.ListGatewayTransactionsTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, reason } = Spreedly.list_gateway_transactions(bogus_env, "SomeToken")
    assert reason =~ "Unable to authenticate"
  end

  test "non existent payment method" do
    { :error, reason } = Spreedly.list_gateway_transactions(env(), "NonExistentToken")
    assert reason =~ "Unable to find the specified gateway"
  end

  test "list transactions" do
    card = create_test_card()
    gateway = create_test_gateway()

    :timer.sleep(1000)
    {:ok, trans_1} = Spreedly.verify(env(), gateway.token, card.token)
    :timer.sleep(1000)
    {:ok, trans_2} = Spreedly.purchase(env(), gateway.token, card.token, 100)

    :timer.sleep(1000)
    {:ok, list} = Spreedly.list_gateway_transactions(env(), gateway.token)

    assert length(list) == 3
    assert Enum.at(list, 1).token == trans_1.token
    assert Enum.at(list, 2).token == trans_2.token
  end

  test "list transactions sorted" do
    card = create_test_card()
    gateway = create_test_gateway()

    :timer.sleep(1000)
    {:ok, trans_1} = Spreedly.verify(env(), gateway.token, card.token)
    :timer.sleep(1000)
    {:ok, trans_2} = Spreedly.purchase(env(), gateway.token, card.token, 100)

    :timer.sleep(1000)
    {:ok, list} = Spreedly.list_gateway_transactions(env(), gateway.token, order: :desc)

    assert length(list) == 3
    assert Enum.at(list, 0).token == trans_2.token
    assert Enum.at(list, 1).token == trans_1.token
  end

end
