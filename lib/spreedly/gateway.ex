defmodule Spreedly.Gateway do

  defstruct ~w(token name description gateway_type state xml)a

  def new_from_xml(xml) do
    XML.into_struct(xml, __MODULE__)
  end

end
