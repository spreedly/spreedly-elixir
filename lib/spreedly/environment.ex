defmodule Spreedly.Environment do

  defstruct [ :environment_key, :access_secret ]

  import Spreedly.URL
  import Spreedly.RequestBody

  def new(environment_key, access_secret) do
    %Spreedly.Environment{environment_key: environment_key, access_secret: access_secret}
  end

  def add_gateway(env, gateway_type) do
    HTTPoison.post(add_gateway_url, add_gateway_body(gateway_type), headers(env))
    |> response(:gateway)
  end

  def add_credit_card(env, options) do
    HTTPoison.post(add_payment_method_url, add_credit_card_body(options), headers(env))
    |> response(:transaction)
  end

  def verify(env, gateway_token, payment_method_token) do
    HTTPoison.post(verify_url(gateway_token), verify_body(payment_method_token), headers(env))
    |> response(:transaction)
  end

  def show_gateway(env, gateway_token) do
    HTTPoison.get(show_gateway_url(gateway_token), headers(env))
    |> response(:gateway) 
  end

  def show_payment_method(env, payment_method_token) do
    HTTPoison.get(show_payment_method_url(payment_method_token), headers(env))
    |> response(:payment_method)
  end

  def show_transaction(env, transaction_token) do
    HTTPoison.get(show_transaction_url(transaction_token), headers(env))
    |> response(:transaction)
  end

  defp response({:ok, %HTTPoison.Response{status_code: code, body: body}}, root_element) do
    cond do
      code in [401, 402, 404] -> error_response(body)
      code in [422] -> unprocessable(body, root_element)
      code in [200, 201] -> ok_response(body, root_element)
    end
  end

  defp response({:error, %HTTPoison.Error{reason: reason}}, _) do
    { :error, reason }
  end

  defp unprocessable(body, root_element) do
    parsed = Poison.decode!(body, keys: :atoms)
    case parsed[:errors] do
      nil -> ok_response(body, root_element)
      _   -> error_response(body)
    end
  end

  defp error_response(body) do
    { :error, body |> extract_reason }
  end

  defp extract_reason(body) do
    Poison.decode!(body)["errors"]
    |> Enum.map_join("\n", &(&1["message"]))
  end

  defp ok_response(body, root_element) do
    { :ok, map_from(body, root_element) }
  end

  defp map_from(body, root_element) do
    Poison.decode!(body, keys: :atoms)[root_element]
    |> Map.put(:response_body, body)
  end

  defp headers(env) do
    encoded = Base.encode64("#{env.environment_key}:#{env.access_secret}")
    [
      "Authorization": "Basic #{encoded}",
      "Content-Type": "application/json"
    ]
  end

end
