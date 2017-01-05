defmodule Remote.RetainPaymentMethodTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, message } = Environment.retain_payment_method(bogus_env, "some_card_token")
    assert message =~ "Unable to authenticate"
  end

  test "non existent" do
    { :error, reason } = Environment.retain_payment_method(env, "non_existent_card")
    assert reason =~ "Unable to find the specified payment method."
  end

  test "successfully retain" do
    {:ok, add_trans } = Environment.add_credit_card(env, card_deets)
    assert add_trans.payment_method.storage_state == "cached"
    {:ok, retain_trans} = Environment.retain_payment_method(env, add_trans.payment_method.token)
    assert retain_trans.payment_method.storage_state == "retained"
    assert retain_trans.transaction_type == "RetainPaymentMethod"
  end

end