defmodule Spreedly do
  @moduledoc """
  An Elixir client implementation of the Spreedly API.

  For more info visit the [Spreedly API docs](https://docs.spreedly.com/reference/api/v1/)
  for a detailed listing of available API methods.

  ## Usage

  API interactions happen with a `Spreedly.Environment`.

      iex> env = Spreedly.Environment.new(environment_key, access_secret)

  Once you have an environment, you can use it to interact with the API.

  ### Run a purchase using a credit card

  You can pattern match on the response.

      iex> case Spreedly.purchase(env, "R8AKGmYwkZrrj2BpWcPge", "RjTFFZQp4MrH2HJNfPwK", 2344) do
              {:ok, %{succeeded: true}} ->
                IO.puts "Success!"
              {:ok, %{succeeded: false, message: msg}} ->
                IO.puts "Declined!"
              {:error, reason} ->
                IO.inspect reason
            end

  ### Show a Transaction

      iex> Spreedly.show_transaction(env, "7f6837d1d22e049f8a47a8cc1fa9")
      {:ok,
      %{created_at: "2016-01-10T16:36:14Z", currency_code: nil, description: nil,
        ...
        state: "gateway_processing_failed", succeeded: false,
        token: "7f6837d1d22e049f8a47a8cc1fa9", transaction_type: "Verification",
        updated_at: "2016-01-10T16:36:14Z"}}

      iex> Spreedly.find_transaction(env, "NonExistentToken")
      {:error, "Unable to find the transaction NonExistentToken."}
  """

  import Spreedly.{Base, Path, RequestBody}

  alias Spreedly.Environment

  @spec add_gateway(Environment.t, String.t, map()) :: {:ok, any} | {:error, any}
  def add_gateway(env, gateway_type, gateway_params \\ %{}) do
    post_request(env, add_gateway_path(), add_gateway_body(gateway_type, gateway_params))
  end

  @spec add_receiver(Environment.t, String.t, Keyword.t) :: {:ok, any} | {:error, any}
  def add_receiver(env, receiver_type, options \\ []) do
    post_request(env, add_receiver_path(), add_receiver_body(receiver_type, options))
  end

  @spec add_credit_card(Environment.t, Keyword.t) :: {:ok, any} | {:error, any}
  def add_credit_card(env, options) do
    post_request(env, add_payment_method_path(), add_credit_card_body(options))
  end

  @spec retain_payment_method(Environment.t, String.t) :: {:ok, any} | {:error, any}
  def retain_payment_method(env, token) do
    put_request(env, retain_payment_method_path(token))
  end

  @spec redact_gateway(Environment.t, String.t) :: {:ok, any} | {:error, any}
  def redact_gateway(env, token) do
    put_request(env, redact_gateway_method_path(token))
  end

  @spec redact_payment_method(Environment.t, String.t) :: {:ok, any} | {:error, any}
  def redact_payment_method(env, token) do
    put_request(env, redact_payment_method_path(token))
  end

  @spec store_payment_method(Environment.t, String.t, String.t) :: {:ok, any} | {:error, any}
  def store_payment_method(env, gateway_token, payment_method_token) do
    post_request(env, store_payment_method_path(gateway_token), store_payment_method_body(payment_method_token))
  end

  @doc """
  Make a purchase for the provided gateway token and payment method token
  with optional request body data specified as a keyword list.

  Amount should be provided as a positive integer in cents.

  ## Examples

      purchase(env, "gateway_token", "payment_method_token", 100)
      purchase(env, "gateway_token", "payment_method_token", 100, "USD", [order_id: "44", description: "My purchase"])

  """
  @spec purchase(Environment.t, String.t, String.t, pos_integer, String.t, Keyword.t) :: {:ok, any} | {:error, any}
  def purchase(env, gateway_token, payment_method_token, amount, currency_code \\ "USD", options \\ []) do
    post_request(env,
                 purchase_path(gateway_token),
                 auth_or_purchase_body(payment_method_token, amount, currency_code, options))
  end

  @doc """
  Authorize a payment method to be charged a specific amount for the provided
  gateway token with optional request body data specified as a keyword list.

  Amount should be provided as a positive integer in cents.

  ## Examples

      authorization(env, "gateway_token", "payment_method_token", 100)
      authorization(env, "gateway_token", "payment_method_token", 100, "USD", [order_id: "44", description: "My auth"])

  """
  @spec authorization(Environment.t, String.t, String.t, pos_integer, String.t, Keyword.t) :: {:ok, any} | {:error, any}
  def authorization(env, gateway_token, payment_method_token, amount, currency_code \\ "USD", options \\ []) do
    post_request(env,
                 authorization_path(gateway_token),
                 auth_or_purchase_body(payment_method_token, amount, currency_code, options))
  end

  @spec capture(Environment.t, String.t) :: {:ok, any} | {:error, any}
  def capture(env, transaction_token) do
    post_request(env, capture_path(transaction_token))
  end

  @spec void(Environment.t, String.t) :: {:ok, any} | {:error, any}
  def void(env, transaction_token) do
    post_request(env, void_path(transaction_token))
  end

  @spec credit(Environment.t, String.t) :: {:ok, any} | {:error, any}
  def credit(env, transaction_token) do
    post_request(env, credit_path(transaction_token))
  end

  @doc """
  Determine if a credit card is a chargeable card and available for purchases,
  with optional request body data specified as a keyword list.

  ## Examples

      verify(env, "gateway_token", "payment_method_token")
      verify(env, "gateway_token", "payment_method_token", "USD", [retain_on_success: true])

  """
  @spec verify(Environment.t, String.t, String.t, String.t | nil, Keyword.t) :: {:ok, any} | {:error, any}
  def verify(env, gateway_token, payment_method_token, currency_code \\ nil, options \\ []) do
    post_request(env, verify_path(gateway_token), verify_body(payment_method_token, currency_code, options))
  end

  @spec show_gateway(Environment.t, String.t) :: {:ok, any} | {:error, any}
  def show_gateway(env, gateway_token) do
    get_request(env, show_gateway_path(gateway_token))
  end

  @spec show_receiver(Environment.t, String.t) :: {:ok, any} | {:error, any}
  def show_receiver(env, receiver_token) do
    get_request(env, show_receiver_path(receiver_token))
  end

  @spec show_payment_method(Environment.t, String.t) :: {:ok, any} | {:error, any}
  def show_payment_method(env, payment_method_token) do
    get_request(env, show_payment_method_path(payment_method_token))
  end

  @spec show_transaction(Environment.t, String.t) :: {:ok, any} | {:error, any}
  def show_transaction(env, transaction_token) do
    get_request(env, show_transaction_path(transaction_token))
  end

  @spec show_transcript(Environment.t, String.t) :: {:ok, any} | {:error, any}
  def show_transcript(env, transaction_token) do
    get_request(env, show_transcript_path(transaction_token), [], &transcript_response/1)
  end

  @doc """
  List transactions for the provided payment method token with
  optional query params specified as a keyword list.

  ## Examples

      list_payment_method_transactions(env, "token")
      list_payment_method_transactions(env, "token", [order: :desc, since_token: "token"])

  """
  @spec list_payment_method_transactions(Environment.t, String.t, Keyword.t) :: {:ok, any} | {:error, any}
  def list_payment_method_transactions(env, payment_method_token, params \\ []) do
    get_request(env, list_payment_method_transactions_path(payment_method_token), params)
  end

  @doc """
  List transactions for the provided gateway token with
  optional query params specified as a keyword list.

  ## Examples

      list_gateway_transactions(env, "token")
      list_gateway_transactions(env, "token", order: :desc, since_token: "token"])

  """
  @spec list_gateway_transactions(Environment.t, String.t, Keyword.t) :: {:ok, any} | {:error, any}
  def list_gateway_transactions(env, gateway_token, params \\ []) do
    get_request(env, list_gateway_transactions_path(gateway_token), params)
  end

  @doc """
  Retrieve a list of all transactions for the authenticated environment.

  The list of transactions can be ordered and paginated by providing
  optional query params specified as a keyword list.

  ## Params

    * `:order` - The order of the returned list. Default is `asc`, which returns
      the oldest records first. To list newer records first, use `desc`.

    * `:since_token` - The token of the item to start from (e.g., the last token
      received in the previous list if iterating through records).

    * `:count` - The number of transactions to return. By default returns 20,
      maximum allowed is 100.

  ## Examples

      list_transactions(env)
      list_transactions(env, order: :desc, since_token: "token", count: 100])

  """
  @spec list_transactions(Environment.t, Keyword.t) :: {:ok, any} | {:error, any}
  def list_transactions(env, params \\ []) do
    get_request(env, list_transactions_path(), params)
  end

  defp transcript_response({:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}
  defp transcript_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, body}
  end
  defp transcript_response({:ok, %HTTPoison.Response{status_code: _, body: body}}), do: {:error, body}
end
