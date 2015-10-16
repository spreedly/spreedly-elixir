defmodule Remote.FindPaymentMethodTest do
  use Remote.EnvironmentCase

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, reason } = Environment.find_payment_method(bogus_env, "SomeToken")
    assert reason =~ "Unable to authenticate"
  end

  test "non existent transaction" do
    { :error, reason } = Environment.find_payment_method(env, "NonExistentToken")
    assert reason =~ "Unable to find the specified payment method"
  end

  test "find add payment method" do
    test_card = create_test_card
    {:ok, payment_method } = Environment.find_payment_method(env, test_card.token)
    assert payment_method.payment_method_type == "credit_card"
    assert payment_method.number == "XXXX-XXXX-XXXX-4444"
  end

end
