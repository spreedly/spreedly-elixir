defmodule XML do

  require Record
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  def retrieve(xml, xpath) do
    xml
    |> XPath.select("#{xpath}/text()")
    |> Enum.map(&(xmlText(&1, :value)))
    |> Enum.map(&to_string(&1))
  end

  def retrieve_first(xml, xpath) do
    xml
    |> retrieve(xpath)
    |> List.first
  end

  def into_struct(xml, module, excluded \\ []) do
    keys = module |> struct |> Map.from_struct |> Map.keys |> Enum.reject(&(&1 in [ :xml | excluded ])) 
    model = %{ struct(module) | xml: xml_string_for(xml) }
    Enum.reduce(keys, model, fn(key, acc) ->
      Map.update!(acc, key, fn(_) ->
        XML.retrieve_first(xml, "//#{key}") |> cast_value
      end)
    end)
  end

  defp cast_value("true"), do: true
  defp cast_value("false"), do: false
  defp cast_value(value), do: value
  defp xml_string_for(xml) when is_binary(xml), do: xml
  defp xml_string_for(xml), do: nil

end
