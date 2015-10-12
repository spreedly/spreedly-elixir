defmodule Spreedly.Transaction do

  def new_from_xml(xml) do
    transaction_type_module(xml).new_from_xml(xml)
  end

  defp transaction_type(xml) do
    XML.retrieve_first(xml, "//transaction/transaction_type")
  end

  defp transaction_type_module(xml) do
    Module.concat(["Spreedly", "Transaction", transaction_type(xml)])
  end

end
