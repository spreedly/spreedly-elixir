defmodule Remote.ListTransactionsTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    {:error, reason} = Spreedly.list_transactions(bogus_env)
    assert reason =~ "Unable to authenticate"
  end

  test "list transactions" do
    card = create_test_card()
    gateway = create_test_gateway()

    :timer.sleep(1000)
    {:ok, _trans_1} = Spreedly.verify(env(), gateway.token, card.token)
    :timer.sleep(1000)
    {:ok, _trans_2} = Spreedly.purchase(env(), gateway.token, card.token, 100)

    :timer.sleep(1000)
    {:ok, list} = Spreedly.list_transactions(env())

    assert length(list) >= 3
  end
end
