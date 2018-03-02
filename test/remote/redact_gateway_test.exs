defmodule Remote.RedactGatewayMethodTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    { :error, message } = Spreedly.redact_gateway(bogus_env, "some_gateway_token")
    assert message =~ "Unable to authenticate"
  end

  test "non existent" do
    { :error, reason } = Spreedly.redact_gateway(env(), "non_existent_gateway")
    assert reason =~ "Unable to find the specified gateway."
  end

  test "successfully redact" do
    {:ok, add_gateway } = Spreedly.add_gateway(env(), :test)
    assert  "retained" == add_gateway.state

    {:ok, redact_gateway} = Spreedly.redact_gateway(env(), add_gateway.token)
    assert "redacted" == redact_gateway.gateway.state
    assert "RedactGateway" == redact_gateway.transaction_type
    assert redact_gateway.token
  end
end
