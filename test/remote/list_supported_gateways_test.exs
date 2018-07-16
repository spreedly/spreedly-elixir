defmodule Remote.ListSupportedGatewaysTest do
  use Remote.Environment.Case

  test "list supported gateways" do
    {:ok, response} = Spreedly.list_supported_gateways()

    assert response
  end
end
