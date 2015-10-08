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

  def into_struct(xml, struct, excluded \\ []) do
    keys = Map.from_struct(struct) |> Map.keys |> Enum.reject(&(&1 in excluded))
    Enum.reduce(keys, struct, fn(key, acc) ->
      Map.update!(acc, key, fn(_) ->
        XML.retrieve_first(xml, "//#{key}")
      end)
    end)
  end

end
