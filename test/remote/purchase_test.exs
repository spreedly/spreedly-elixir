defmodule Remote.PurchaseTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, reason } = Environment.purchase(bogus_env, "gateway_token", "payment_method_token", 100)
    assert reason =~ "Unable to authenticate"
  end

  test "payment method not found" do
    { :error, reason } = Environment.purchase(env(), create_test_gateway().token, "unknown_card", 100)
    assert reason =~ "There is no payment method"
  end

  test "gateway not found" do
    { :error, reason } = Environment.purchase(env(), "unknown_gateway", create_test_card().token, 100)
    assert reason == "Unable to find the specified gateway."
  end

  test "successful purchase" do
    {:ok, trans } = Environment.purchase(env(), create_test_gateway().token, create_test_card().token, 100)
    assert trans.succeeded == true
    assert trans.payment_method.last_name == "Cauthon"
    assert trans.transaction_type == "Purchase"
  end

  test "successful purchase with options" do
    {:ok, trans } = Environment.purchase(env(), create_test_gateway().token, create_test_card().token, 100, "GBP", order_id: "44", description: "Wow")
    assert trans.succeeded == true
    assert trans.description == "Wow"
    assert trans.order_id == "44"
    assert trans.currency_code == "GBP"
  end

  test "failed purchase" do
    {:ok, trans } = Environment.purchase(env(), create_test_gateway().token, create_declined_test_card().token, 100)
    assert trans.succeeded == false
    assert trans.state == "gateway_processing_failed"
    assert trans.message == "Unable to process the purchase transaction."
  end

end
