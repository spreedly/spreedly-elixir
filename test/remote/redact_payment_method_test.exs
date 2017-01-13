defmodule Remote.RedactPaymentMethodTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, message } = Environment.redact_payment_method(bogus_env, "some_card_token")
    assert message =~ "Unable to authenticate"
  end

  test "non existent" do
    { :error, reason } = Environment.redact_payment_method(env(), "non_existent_card")
    assert reason =~ "Unable to find the specified payment method."
  end

  test "successfully redact" do
    {:ok, add_trans } = Environment.add_credit_card(env(), card_deets(retained: true))
    assert add_trans.payment_method.storage_state == "retained"
    {:ok, redact_trans} = Environment.redact_payment_method(env(), add_trans.payment_method.token)
    assert redact_trans.payment_method.storage_state == "redacted"
    assert redact_trans.transaction_type == "RedactPaymentMethod"
  end

end
