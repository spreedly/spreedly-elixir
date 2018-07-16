defmodule Remote.StorePaymentMethodTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    {:error, message} = Spreedly.store_payment_method(bogus_env, "some_gateway", "some_card_token")
    assert message =~ "Unable to authenticate"
  end

  test "non existent payment method" do
    {:error, reason} = Spreedly.store_payment_method(env(), create_test_gateway().token, "non_existent_card")
    assert reason =~ "There is no payment method corresponding to the specified payment method token."
  end

  test "successfully store payment method" do
    {:ok, store_trans} = Spreedly.store_payment_method(env(), create_test_gateway().token, create_test_card().token)
    assert store_trans.payment_method.storage_state == "retained"
    assert store_trans.transaction_type == "Store"
    assert store_trans.succeeded == true
  end
end
