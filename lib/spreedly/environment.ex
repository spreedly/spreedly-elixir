defmodule Spreedly.Environment do
  @moduledoc """
  The Spreedly Environment data structure required for
  protected api calls. An environment is the combinration of
  the Spreedly environment key and the access secret.
  """

  defstruct [:environment_key, :access_secret]

  @typedoc "The Spreedly environment made of up the environment key and access secret"
  @type t :: %__MODULE__{environment_key: String.t, access_secret: String.t}

  @spec new(String.t, String.t) :: t
  def new(environment_key, access_secret) do
    %__MODULE__{environment_key: environment_key, access_secret: access_secret}
  end

end
