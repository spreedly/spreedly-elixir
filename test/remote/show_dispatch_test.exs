defmodule Remote.ShowDispatchTest do
  use Remote.Environment.Case

  test "invalid credentials" do
    bogus_env = Environment.new("invalid", "credentials")
    {:error, reason} = Spreedly.show_dispatch(bogus_env, "SomeToken")
    assert reason =~ "Unable to authenticate"
  end

  test "non existent transaction" do
    {:error, reason} = Spreedly.show_dispatch(env(), "NonExistentToken")
    assert reason =~ "translation missing: en.errors.dispatch_not_found"
  end

  test "invalid token" do
    {:error, reason} = Spreedly.show_dispatch(env(), "http://subdomain.spreedly.test")

    assert reason =~ "{\"status\":404,\"error\":\"Not Found\"}"
  end

  test "show dispatch transaction" do
    {:ok, dispatch} = Spreedly.show_dispatch(env(), create_dispatch().token)
    assert dispatch.state == "success"
    assert Enum.count(dispatch.transactions) == 1
  end
end
