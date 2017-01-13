defmodule Remote.VerificationTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, reason } = Environment.verify(bogus_env, "gateway_token", "payment_method_token")
    assert reason =~ "Unable to authenticate"
  end

  test "payment method not found" do
    { :error, reason } = Environment.verify(env(), create_test_gateway().token, "unknown_card")
    assert reason =~ "There is no payment method"
  end

  test "gateway not found" do
    { :error, reason } = Environment.verify(env(), "unknown_gateway", create_test_card().token)
    assert reason == "Unable to find the specified gateway."
  end

  test "bogus currency" do
    {:error, reason } = Environment.verify(env(), create_test_gateway().token, create_test_card().token, "HUH")
    assert reason == "Currency code is invalid"
  end

  test "successful verify" do
    {:ok, trans } = Environment.verify(env(), create_test_gateway().token, create_test_card().token)
    assert trans.succeeded == true
    assert trans.payment_method.first_name == "Matrim"
    assert trans.transaction_type == "Verification"
  end

  test "successful verify with legitimate currency_code" do
    {:ok, trans } = Environment.verify(env(), create_test_gateway().token, create_test_card().token, "GBP")
    assert trans.succeeded == true
    assert trans.currency_code == "GBP"
  end

  test "successful verify with options" do
    {:ok, trans } = Environment.verify(env(), create_test_gateway().token, create_test_card().token, "GBP", order_id: "44", description: "Wow")
    assert trans.succeeded == true
    assert trans.description == "Wow"
    assert trans.order_id == "44"
    assert trans.currency_code == "GBP"
  end

  test "failed verify" do
    {:ok, trans } = Environment.verify(env(), create_test_gateway().token, create_declined_test_card().token)
    assert trans.succeeded == false
    assert trans.state == "gateway_processing_failed"
    assert trans.payment_method.first_name == "Matrim"
    assert trans.message == "Unable to process the verify transaction."
  end

end
