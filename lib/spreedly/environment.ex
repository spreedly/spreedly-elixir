defmodule Spreedly.Environment do

  defstruct [ :environment_key, :access_secret ]

  import Spreedly.URL
  import Spreedly.RequestBody

  def new(environment_key, access_secret) do
    %Spreedly.Environment{environment_key: environment_key, access_secret: access_secret}
  end

  def add_gateway(env, gateway_type) do
    HTTPoison.post(add_gateway_url, add_gateway_body(gateway_type), headers(env))
    |> response(Spreedly.Gateway)
  end

  def add_credit_card(env, options) do
    HTTPoison.post(add_payment_method_url, add_credit_card_body(options), headers(env))
    |> response(Spreedly.Transaction)
  end

  def verify(env, gateway_token, payment_method_token) do
    HTTPoison.post(verify_url(gateway_token), verify_body(payment_method_token), headers(env))
    |> response(Spreedly.Transaction)
  end

  def find_gateway(env, gateway_token) do
    HTTPoison.get(find_gateway_url(gateway_token), headers(env))
    |> response(Spreedly.Gateway)
  end

  def find_payment_method(env, payment_method_token) do
    HTTPoison.get(find_payment_method_url(payment_method_token), headers(env))
    |> response(Spreedly.PaymentMethod)
  end

  def find_transaction(env, transaction_token) do
    HTTPoison.get(find_transaction_url(transaction_token), headers(env))
    |> response(Spreedly.Transaction)
  end

  defp response({:ok, %HTTPoison.Response{status_code: code, body: body}}, return_struct) do
    cond do
      code in [401, 402, 404] -> error_response(body)
      code in [422] -> unprocessable(body, return_struct)
      code in [200, 201] -> ok_response(body, return_struct)
    end
  end

  defp response({:error, %HTTPoison.Error{reason: reason}}, _) do
    { :error, reason }
  end

  defp unprocessable(body, return_struct) do
    case XPath.select(body, "//errors/error") do
      [] -> ok_response(body, return_struct)
      _ -> error_response(body)
    end
  end

  defp error_response(body) do
    { :error, body |> xml_errors }
  end

  defp ok_response(body, return_struct) do
    { :ok, return_struct.new_from_xml(body) }
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
