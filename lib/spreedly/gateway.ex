defmodule Spreedly.Gateway do

  defstruct ~w(token name description gateway_type state)a

  def new_from_xml(xml) do
    XML.into_struct(xml, %Spreedly.Gateway{})
  end

end
