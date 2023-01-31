defmodule Membrane.VideoCompositor.Compound.Layout do
  @moduledoc false

  @type definition_t :: struct() | module()
  @type name_t :: any()
  @type input_t :: any()

  @callback render() :: any()
end
