defmodule Remote.FindTransactionTest do
  @moduletag [:remote]
  use ExUnit.Case, async: true
  alias Spreedly.Environment

  test "invalid credentials" do
    # bogus_env = Environment.new("invalid", "credentials")
    # { :error, message } = Environment.find_transaction(bogus_env, "SomeToken")
    # assert message =~ "Unable to authenticate"
  end

  test "non existent transaction" do
    # { :error, message } = Environment.find_transaction(env, "NonExistentToken")
    # assert message == "Blah blah"
  end

  test "find transaction" do
  end

  # defp env do
  #   Environment.new(Application.get_env(:spreedly, :environment_key), Application.get_env(:spreedly, :access_secret))
  # end

end
