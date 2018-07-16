defmodule Remote.CaptureTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    {:error, reason} = Spreedly.capture(bogus_env, "gateway_token")
    assert reason =~ "Unable to authenticate"
  end

  test "transaction method not found" do
    {:error, reason} = Spreedly.capture(env(), "no_transaction_token")
    assert reason =~ "Unable to find the specified reference transaction."
  end

  test "successful capture" do
    {:ok, trans} = Spreedly.capture(env(), create_auth_transaction().token)
    assert trans.succeeded == true
    assert trans.transaction_type == "Capture"
  end
end
