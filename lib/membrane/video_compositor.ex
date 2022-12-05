defmodule Membrane.VideoCompositor do
  @moduledoc """
  A bin responsible for doing framerate conversion on all input videos and piping them into the compositor element.
  """

  use Membrane.Bin
  alias Membrane.FramerateConverter
  alias Membrane.RawVideo
  alias Membrane.VideoCompositor.CompositorElement

  def_options caps: [
                spec: RawVideo.t(),
                description: "Caps for the output video of the compositor"
              ],
              real_time: [
                spec: boolean(),
                description: "Set compositor into real_time mode",
                default: false
              ]

  def_input_pad :input,
    caps: {RawVideo, pixel_format: :I420},
    demand_unit: :buffers,
    availability: :on_request,
    options: [
      position: [
        spec: {integer(), integer()},
        description:
          "Initial position of the video on the screen, given in the pixels, relative to the upper left corner of the screen",
        default: {0, 0}
      ],
      timestamp_offset: [
        spec: Membrane.Time.non_neg_t(),
        description: "Input stream PTS offset in nanoseconds. Must be non-negative.",
        default: 0
      ]
    ]

  def_output_pad :output,
    demand_unit: :buffers,
    caps: {RawVideo, pixel_format: :I420},
    availability: :always

  @impl true
  def handle_init(options) do
    children = %{
      compositor: %CompositorElement{caps: options.caps, real_time: options.real_time}
    }

    links = [
      link(:compositor) |> to_bin_output(:output)
    ]

    spec = %ParentSpec{children: children, links: links}

    state = %{
      output_caps: options.caps
    }

    {{:ok, spec: spec}, state}
  end

  @impl true
  def handle_pad_added(pad, context, state) do
    converter = {:framerate_converter, make_ref()}

    children = %{
      converter => %FramerateConverter{framerate: state.output_caps.framerate}
    }

    links = [
      link_bin_input(pad)
      |> to(converter)
      |> via_in(:input,
        options: [
          position: context.options.position,
          timestamp_offset: context.options.timestamp_offset
        ]
      )
      |> to(:compositor)
    ]

    spec = %ParentSpec{children: children, links: links}

    {{:ok, spec: spec}, state}
  end
end
