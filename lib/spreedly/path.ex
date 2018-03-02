defmodule Spreedly.Path do
  @moduledoc false

  def add_gateway_path do
    "/gateways.json"
  end

  def add_receiver_path do
    "/receivers.json"
  end

  def authorization_path(gateway_token) do
    "/gateways/#{gateway_token}/authorize.json"
  end

  def purchase_path(gateway_token) do
    "/gateways/#{gateway_token}/purchase.json"
  end

  def verify_path(gateway_token) do
    "/gateways/#{gateway_token}/verify.json"
  end

  def capture_path(transaction_token) do
    "/transactions/#{transaction_token}/capture.json"
  end

  def void_path(transaction_token) do
    "/transactions/#{transaction_token}/void.json"
  end

  def credit_path(transaction_token) do
    "/transactions/#{transaction_token}/credit.json"
  end

  def show_gateway_path(token) do
    "/gateways/#{token}.json"
  end

  def show_receiver_path(token) do
    "/receivers/#{token}.json"
  end

  def show_payment_method_path(token) do
    "/payment_methods/#{token}.json"
  end

  def show_transaction_path(token) do
    "/transactions/#{token}.json"
  end

  def show_transcript_path(token) do
    "/transactions/#{token}/transcript"
  end

  def add_payment_method_path do
    "/payment_methods.json"
  end

  def retain_payment_method_path(token) do
    "/payment_methods/#{token}/retain.json"
  end

  def redact_gateway_method_path(token) do
    "/gateways/#{token}/redact.json"
  end

  def redact_payment_method_path(token) do
    "/payment_methods/#{token}/redact.json"
  end

  def store_payment_method_path(gateway_token) do
    "/gateways/#{gateway_token}/store.json"
  end

  def list_payment_method_transactions_path(token) do
    "/payment_methods/#{token}/transactions.json"
  end

  def list_gateway_transactions_path(token) do
    "/gateways/#{token}/transactions.json"
  end

  def list_transactions_path do
    "/transactions.json"
  end

end
