defmodule XPath do

  def select(xml_string, xpath_expression) when is_binary(xml_string) do
    select(parsed(xml_string), xpath_expression)
  end

  def select(node, xpath_expression) do
    :xmerl_xpath.string(String.to_char_list(xpath_expression), node)
  end

  defp parsed(xml_string) do
    { parsed_xml, _ } = :xmerl_scan.string(:erlang.bitstring_to_list(xml_string))
    parsed_xml
  end

end
