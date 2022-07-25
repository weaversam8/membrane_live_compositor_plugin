defmodule Membrane.VideoCompositor.Pipeline do
  @moduledoc """
  Pipeline for testing simple composing of two videos, by placing one above the other.
  """

  use Membrane.Pipeline

  # options = [%{first_raw_video_path, second_raw_video_path, output_path, video_width,  implementation}]
  def handle_init(options) do
    [options | _] = options
    first_raw_video_path = options.first_raw_video_path
    second_raw_video_path = options.second_raw_video_path
    output_path = options.output_path

    children = %{
      first_file: %Membrane.File.Source{location: first_raw_video_path},
      second_file: %Membrane.File.Source{location: second_raw_video_path},
      first_parser: %Membrane.RawVideo.Parser{
        framerate: {options.video_framerate, 1},
        width: options.video_width,
        height: options.video_height,
        pixel_format: :I420
      },
      second_parser: %Membrane.RawVideo.Parser{
        framerate: {options.video_framerate, 1},
        width: options.video_width,
        height: options.video_height,
        pixel_format: :I420
      },
      video_composer: Membrane.VideoCompositor,
      encoder: Membrane.H264.FFmpeg.Encoder,
      file_sink: %Membrane.File.Sink{location: output_path}
    }

    links = [
      link(:first_file) |> to(:first_parser),
      link(:second_file) |> to(:second_parser),
      link(:first_parser) |> via_in(:first_input) |> to(:video_composer),
      link(:second_parser) |> via_in(:second_input) |> to(:video_composer),
      link(:video_composer) |> to(:encoder) |> to(:file_sink)
    ]

    {{:ok, spec: %ParentSpec{children: children, links: links}}, %{}}
  end

  def handle_element_end_of_stream(_element, _cts, state) do
    {:ok, state}
  end
end
