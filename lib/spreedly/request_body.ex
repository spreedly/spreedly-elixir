defmodule Spreedly.RequestBody do

  def add_gateway_body(gateway_type) do
    %{
      gateway:
      %{
        gateway_type: gateway_type
      }
    }
    |> Poison.encode!
  end

  def add_credit_card_body(options) do
    %{
      payment_method:
      %{
        email: options[:email],
        retained: options[:retained],
        data: options[:data],
        credit_card: credit_card_fields(options)
      }
    }
    |> Poison.encode!
  end

  def verify_body(payment_method_token, options \\ []) do
    %{
      transaction:
      %{
        payment_method_token: payment_method_token,
        retain_on_success: options[:retain_on_success],
        currency_code: options[:currency_code]
      }
    }
    |> Poison.encode!
  end

  defp add(symbols, options) do
    symbols |> Enum.filter_map(&(options[&1]), fn(each) ->
      { each, options[each] }
    end)
  end

  defp credit_card_fields(options) do
    ~w(first_name last_name full_name month year number verification_value address1 address2 city state zip country phone_number company)a
    |> Keyword.new(fn (x) -> {x, options[x]} end)
    |> Map.new
  end

end
