defmodule Remote.AuthorizationTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    {:error, reason} = Spreedly.authorization(bogus_env, "gateway_token", "payment_method_token", 100)
    assert reason =~ "Unable to authenticate"
  end

  test "payment method not found" do
    {:error, reason} = Spreedly.authorization(env(), create_test_gateway().token, "unknown_card", 100)
    assert reason =~ "There is no payment method"
  end

  test "gateway not found" do
    {:error, reason} = Spreedly.authorization(env(), "unknown_gateway", create_test_card().token, 100)
    assert reason == "Unable to find the specified gateway."
  end

  test "successful authorization" do
    {:ok, trans} = Spreedly.authorization(env(), create_test_gateway().token, create_test_card().token, 100)
    assert trans.succeeded == true
    assert trans.payment_method.last_name == "Cauthon"
    assert trans.transaction_type == "Authorization"
  end

  test "successful authorization with options" do
    {:ok, trans} =
      Spreedly.authorization(
        env(),
        create_test_gateway().token,
        create_test_card().token,
        100,
        "GBP",
        order_id: "44",
        description: "Wow"
      )

    assert trans.succeeded == true
    assert trans.description == "Wow"
    assert trans.order_id == "44"
    assert trans.currency_code == "GBP"
  end

  test "failed authorization" do
    {:ok, trans} = Spreedly.authorization(env(), create_test_gateway().token, create_declined_test_card().token, 100)
    assert trans.succeeded == false
    assert trans.state == "gateway_processing_failed"
    assert trans.message == "Unable to process the authorize transaction."
  end
end
