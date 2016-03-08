defmodule Spreedly.Environment do

  defstruct [ :environment_key, :access_secret ]

  import Spreedly.URL
  import Spreedly.RequestBody

  def new(environment_key, access_secret) do
    %Spreedly.Environment{environment_key: environment_key, access_secret: access_secret}
  end

  def add_gateway(env, gateway_type) do
    HTTPoison.post(add_gateway_url, add_gateway_body(gateway_type), headers(env))
    |> response
  end

  def add_credit_card(env, options) do
    HTTPoison.post(add_payment_method_url, add_credit_card_body(options), headers(env))
    |> response
  end

  def purchase(env, gateway_token, payment_method_token, amount, currency_code \\ "USD", options \\ []) do
    HTTPoison.post(purchase_url(gateway_token), purchase_body(payment_method_token, amount, currency_code, options), headers(env))
    |> response
  end

  def verify(env, gateway_token, payment_method_token, currency_code \\ nil, options \\ []) do
    HTTPoison.post(verify_url(gateway_token), verify_body(payment_method_token, currency_code, options), headers(env))
    |> response
  end

  def show_gateway(env, gateway_token) do
    HTTPoison.get(show_gateway_url(gateway_token), headers(env))
    |> response
  end

  def show_payment_method(env, payment_method_token) do
    HTTPoison.get(show_payment_method_url(payment_method_token), headers(env))
    |> response
  end

  def show_transaction(env, transaction_token) do
    HTTPoison.get(show_transaction_url(transaction_token), headers(env))
    |> response
  end

  def show_transcript(env, transaction_token) do
    HTTPoison.get(show_transcript_url(transaction_token), headers(env))
    |> transcript_response
  end

  def list_payment_method_transactions(env, payment_method_token, options \\ []) do
    HTTPoison.get(list_payment_method_transactions_url(payment_method_token, options), headers(env))
    |> response
  end

  def list_gateway_transactions(env, gateway_token, options \\ []) do
    HTTPoison.get(list_gateway_transactions_url(gateway_token, options), headers(env))
    |> response
  end

  defp response({:error, %HTTPoison.Error{reason: reason}}) do
    { :error, reason }
  end
  defp response({:ok, %HTTPoison.Response{status_code: code, body: body}}) when code in [401, 402, 404] do
    error_response(body)
  end
  defp response({:ok, %HTTPoison.Response{status_code: code, body: body}}) when code in [200, 201] do
    ok_response(body)
  end
  defp response({:ok, %HTTPoison.Response{status_code: 422, body: body}}) do
    unprocessable(body)
  end

  def unprocessable(body = ~s[{"errors":] <> _rest), do: error_response(body)
  def unprocessable(body), do: ok_response(body)

  defp error_response(body) do
    { :error, body |> extract_reason }
  end

  defp extract_reason(body) do
    parse(body)[:errors]
    |> Enum.map_join("\n", &(&1.message))
  end

  defp ok_response(body) do
    { :ok, map_from(body) }
  end

  defp map_from(body) do
    parse(body) |> Map.values |> List.first
  end

  defp parse(body) do
    Poison.decode!(body, keys: :atoms)
  end

  defp headers(env) do
    encoded = Base.encode64("#{env.environment_key}:#{env.access_secret}")
    [
      "Authorization": "Basic #{encoded}",
      "Content-Type": "application/json"
    ]
  end

  defp transcript_response({:error, %HTTPoison.Error{reason: reason}}), do: { :error, reason }
  defp transcript_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: { :ok, body }
  defp transcript_response({:ok, %HTTPoison.Response{status_code: _, body: body}}), do: { :error, body }

end
