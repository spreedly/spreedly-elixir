defmodule XPath do

  def select(string, xpath_expression) do
    :xmerl_xpath.string(String.to_char_list(xpath_expression), parsed(string))
  end

  defp parsed(string) do
    { parsed_string, _ } = :xmerl_scan.string(:erlang.bitstring_to_list(string))
    parsed_string
  end

end
