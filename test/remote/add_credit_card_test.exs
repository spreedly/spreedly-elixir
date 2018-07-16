defmodule Remote.AddCreditCardTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    {:error, message} = Spreedly.add_credit_card(bogus_env, card_deets())
    assert message =~ "Unable to authenticate"
  end

  test "failed with validation error" do
    {:error, reason} = Spreedly.add_credit_card(env(), card_deets(first_name: "  ", last_name: nil))
    assert reason =~ "First name can't be blank\nLast name can't be blank"
  end

  test "paid account required" do
    {:error, reason} = Spreedly.add_credit_card(env(), card_deets(number: "44421"))
    assert reason =~ "has not been activated for real transactions"
  end

  test "successfully add" do
    {:ok, trans} = Spreedly.add_credit_card(env(), card_deets())
    assert trans.transaction_type == "AddPaymentMethod"
    assert trans.payment_method.first_name == "Matrim"
    assert trans.message == "Succeeded!"
    assert trans.payment_method.number == "XXXX-XXXX-XXXX-4444"
    assert trans.payment_method.token
    assert trans.token
    assert trans.payment_method.token != trans.token
    assert "cached" == trans.payment_method.storage_state
    assert trans.succeeded == true
  end

  test "retain on create" do
    {:ok, trans} = Spreedly.add_credit_card(env(), card_deets(retained: true))
    assert "retained" == trans.payment_method.storage_state
  end

  test "add using full name" do
    {:ok, trans} =
      Spreedly.add_credit_card(env(), card_deets(full_name: "Kvothe OFerglintine", first_name: nil, last_name: nil))

    assert "Kvothe OFerglintine" == trans.payment_method.full_name
    assert "Kvothe" == trans.payment_method.first_name
    assert "OFerglintine" == trans.payment_method.last_name
  end
end
