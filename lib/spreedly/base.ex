defmodule Spreedly.Base do
  @moduledoc false
  use HTTPoison.Base

  alias HTTPoison.{Response, AsyncResponse, Error}
  alias Spreedly.Environment

  @spec get_request(Environment.t, String.t, Keyword.t, ((any) -> any)) :: {:ok, any} | {:error, any}
  def get_request(env, path, params \\ [], response_callback \\ &process_response/1) do
    api_request(:get, env, path, "", [params: params], response_callback)
  end

  @spec post_request(Environment.t, String.t, any) :: {:ok, any} | {:error, any}
  def post_request(env, path, body \\ "") do
    api_request(:post, env, path, body)
  end

  @spec put_request(Environment.t, String.t, any) :: {:ok, any} | {:error, any}
  def put_request(env, path, body \\ "") do
    api_request(:put, env, path, body)
  end

  @spec api_request(atom, Environment.t, String.t, any, Keyword.t, ((any) -> any)) :: {:ok, any} | {:error, any}
  defp api_request(method, env, path, body, options \\ [], response_callback \\ &process_response/1) do
    method
    |> request(path, body, headers(env), [{:recv_timeout, receive_timeout()} | options])
    |> response_callback.()
  end

  @doc """
  Override `HTTPoison.Base` `process_url`.

  Called in order to process the url passed to any request method before
  actually issuing the request. Concatenates the passed `path` with the
  `base_url` application setting.

      Application.get_env(:spreedly, :base_url)

  """
  @spec process_url(path :: binary) :: binary
  def process_url(path) do
    base_url() <> path
  end

  @spec process_response({:ok, Response.t | AsyncResponse.t} | {:error, Error.t}) :: {:ok, any} | {:error, any}
  defp process_response({:ok, %Response{status_code: code, body: body}}) when code in [200, 201, 202] do
    ok_response(body)
  end
  defp process_response({:ok, %Response{status_code: code, body: body}}) when code in [401, 402, 404] do
    error_response(body)
  end
  defp process_response({:ok, %Response{status_code: code, body: body}}) when code in [422, 403] do
    unprocessable(body)
  end
  defp process_response({:error, %Error{reason: reason}}) do
    {:error, reason}
  end

  defp unprocessable(body = ~s[{"errors":] <> _rest), do: error_response(body)
  defp unprocessable(body), do: ok_response(body)

  defp error_response(body) do
    {:error, body |> extract_reason}
  end

  defp extract_reason(body) do
    parse(body)[:errors]
    |> Enum.map_join("\n", &(&1.message))
  end

  defp ok_response(body) do
    {:ok, map_from(body)}
  end

  defp map_from(body) do
    body
    |> parse()
    |> Map.values
    |> List.first
  end

  defp parse(body) do
    Poison.decode!(body, keys: :atoms)
  end

  @spec headers(Environment.t) :: headers
  defp headers(env) do
    encoded = Base.encode64("#{env.environment_key}:#{env.access_secret}")
    [
      {"Authorization", "Basic #{encoded}"},
      {"Content-Type", "application/json"}
    ]
  end

  defp base_url do
    Application.get_env(:spreedly, :base_url, "https://core.spreedly.com/v1")
  end

  defp receive_timeout do
    Application.get_env(:spreedly, :receive_timeout, 10_000)
  end
end
