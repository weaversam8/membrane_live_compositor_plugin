defmodule Membrane.VideoCompositor.Wgpu do
  @moduledoc """
  This module implements video composition in wgpu
  """
  @behaviour Membrane.VideoCompositor.FrameCompositor

  alias Membrane.VideoCompositor.Implementations.OpenGL.Native.Rust.Position
  alias Membrane.VideoCompositor.Implementations.OpenGL.Native.Rust.RawVideo
  alias Membrane.VideoCompositor.Implementations.Wgpu.Native

  @impl true
  def init(output_caps) do
    {:ok, output_caps} = RawVideo.from_membrane_raw_video(output_caps)
    Native.init(output_caps)
  end

  @impl true
  def merge_frames(frames, internal_state) do
    {Native.join_frames(internal_state, frames), internal_state}
  end

  @impl true
  def add_video(id, input_caps, position, internal_state) do
    {:ok, input_caps} = RawVideo.from_membrane_raw_video(input_caps)
    {:ok, position} = Position.from_tuple(position)
    :ok = Native.add_video(internal_state, id, input_caps, position)
    {:ok, internal_state}
  end

  @impl true
  def set_position(id, position, internal_state) do
    {:ok, position} = Position.from_tuple(position)
    {Native.set_position(internal_state, id, position), internal_state}
  end

  @impl true
  def remove_video(id, internal_state) do
    :ok = Native.remove_video(internal_state, id)
    {:ok, internal_state}
  end
end
