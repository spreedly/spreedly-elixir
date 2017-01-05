defmodule Remote.CreditTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, reason } = Environment.void(bogus_env, "gateway_token")
    assert reason =~ "Unable to authenticate"
  end

  test "transaction method not found" do
    { :error, reason } = Environment.credit(env, "no_transaction_token")
    assert reason =~ "Unable to find the specified reference transaction."
  end

  test "successful void" do
    {:ok, trans } = Environment.credit(env, create_purchase_transaction.token)
    assert trans.succeeded == true
    assert trans.transaction_type == "Credit"
  end

end