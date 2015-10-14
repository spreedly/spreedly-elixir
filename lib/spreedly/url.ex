defmodule Spreedly.URL do

  def add_gateway_url do
    "#{base_url}/gateways.xml"
  end

  def verify_url(gateway_token) do
    "#{base_url}/gateways/#{gateway_token}/verify.xml"
  end

  def find_gateway_url(gateway_token) do
    "#{base_url}/gateways/#{gateway_token}.xml"
  end

  def find_transaction_url(transaction_token) do
    "#{base_url}/transactions/#{transaction_token}.xml"
  end

  def add_payment_method_url do
    "#{base_url}/payment_methods.xml"
  end

  defp base_url do
    "https://core.spreedly.com/v1"
  end

end
