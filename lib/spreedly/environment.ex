defmodule Spreedly.Environment do

  defstruct [ :environment_key, :access_secret ]

  import XmlBuilder
  import Spreedly.URL
  alias Spreedly.Environment

  def new(environment_key, access_secret) do
    %Environment{environment_key: environment_key, access_secret: access_secret}
  end

  def add_gateway(env, gateway_type) do
    case HTTPoison.post(add_gateway_url, add_gateway_body(gateway_type), headers(env)) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code in [401, 422, 402] ->
        { :error, body |> xml_errors }
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code in [200, 201] ->
        { :ok, Spreedly.Gateway.new_from_xml(body) }
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def add_credit_card(env, options) do
    case HTTPoison.post(add_payment_method_url, add_credit_card_body(options), headers(env)) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code in [401, 422, 402] ->
        { :error, body |> xml_errors }
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code in [200, 201] ->
        { :ok, Spreedly.Transaction.AddPaymentMethod.new_from_xml(body) }
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def verify(env, gateway_token, payment_method_token) do
    case HTTPoison.post(verify_url(gateway_token), verify_body(payment_method_token), headers(env)) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code in [401, 422, 402, 404] ->
        { :error, body |> xml_errors }
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code in [200, 201] ->
        { :ok, Spreedly.Transaction.Verify.new_from_xml(body) }
      {:error, %HTTPoison.Error{reason: reason}} -> { :error, reason }
    end
  end

  defp add_gateway_body(gateway_type) do
    element(:gateway, gateway_type: gateway_type)
    |> generate
  end

  defp add_credit_card_body(options) do
    card_fields = ~w(first_name last_name full_name month year number verification_value address1 address2 city state zip country phone_number company)a

    element(
      payment_method: [
        add(~w(email retained data)a, options),
        credit_card: add(card_fields, options)
      ])
    |> generate
  end

  defp add(symbols, options) do
    symbols |> Enum.filter_map &(options[&1]), fn(each) ->
      { each, options[each] }
    end
  end

  defp verify_body(payment_method_token) do
    element(:transaction, payment_method_token: payment_method_token)
    |> generate
  end

  defp xml_errors(xml) do
    XML.retrieve(xml, "//errors/error") |> Enum.join("\n")
  end

  defp headers(env) do
    encoded = Base.encode64("#{env.environment_key}:#{env.access_secret}")
    [
      "Authorization": "Basic #{encoded}",
      "Content-Type": "text/xml"
    ]
  end

end
