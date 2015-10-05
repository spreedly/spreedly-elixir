defmodule Spreedly.Environment do

  defstruct [ :environment_key, :access_secret ]

  import XmlBuilder
  alias Spreedly.Environment

  def new(environment_key, access_secret) do
    %Environment{environment_key: environment_key, access_secret: access_secret}
  end

  def add_gateway(env, gateway_type) do
    url =  "https://core.spreedly.com/v1/gateways.xml"
    case HTTPoison.post(url, add_gateway_body(gateway_type), headers(env)) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code in [401, 422, 402] ->
        { :error, body |> xml_errors }
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code in [200, 201] ->
        { :ok, Spreedly.Gateway.new_from_xml(body) }
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp add_gateway_body(gateway_type) do
    element(:gateway, gateway_type: gateway_type)
    |> generate
  end
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
