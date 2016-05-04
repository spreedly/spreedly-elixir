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

  def add_receiver_body(receiver_type, options) do
    %{ receiver: receiver_details(receiver_type, options) }
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

  def purchase_body(payment_method_token, amount, currency_code, options) do
    %{
      transaction:
      %{
        payment_method_token: payment_method_token,
        amount: amount,
        currency_code: currency_code
      } |> Map.merge(Map.new(options))
    }
    |> Poison.encode!
  end

  def verify_body(payment_method_token, currency_code, options) do
    %{
      transaction:
      %{
        payment_method_token: payment_method_token,
        currency_code: currency_code,
      } |> Map.merge(Map.new(options))
    }
    |> Poison.encode!
  end

  defp credit_card_fields(options) do
    ~w(first_name last_name full_name month year number verification_value address1 address2 city state zip country phone_number company)a
    |> Keyword.new(fn (x) -> {x, options[x]} end)
    |> Map.new
  end

  defp receiver_details(:test, options) do
    %{ receiver_type: :test, hostnames: options[:hostnames] }
  end

  defp receiver_details(receiver_type, options) do
    %{ receiver_type: receiver_type }
  end


end
