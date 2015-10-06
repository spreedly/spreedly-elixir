defmodule Spreedly.URL do

  def add_gateway_url do
    "#{base_url}/gateways.xml"
  end

  def verify_url(gateway_token) do
    "#{base_url}/gateways/#{gateway_token}/verify.xml"
  end

  defp base_url do
    "https://core.spreedly.com/v1"
  end

end
