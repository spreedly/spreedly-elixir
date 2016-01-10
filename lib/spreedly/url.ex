defmodule Spreedly.URL do

  def add_gateway_url do
    "#{base_url}/gateways.json"
  end

  def purchase_url(gateway_token) do
    "#{base_url}/gateways/#{gateway_token}/purchase.json"
  end

  def verify_url(gateway_token) do
    "#{base_url}/gateways/#{gateway_token}/verify.json"
  end

  def show_gateway_url(token) do
    "#{base_url}/gateways/#{token}.json"
  end

  def show_payment_method_url(token) do
    "#{base_url}/payment_methods/#{token}.json"
  end

  def show_transaction_url(token) do
    "#{base_url}/transactions/#{token}.json"
  end

  def add_payment_method_url do
    "#{base_url}/payment_methods.json"
  end

  defp base_url do
    "https://core.spreedly.com/v1"
  end

end
