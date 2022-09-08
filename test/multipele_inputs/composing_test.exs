defmodule Membrane.VideoCompositor.MultipleInputs.ComposingTest do
  @moduledoc false
  use ExUnit.Case

  import Membrane.Testing.Assertions

  alias Membrane.RawVideo
  alias Membrane.Testing.Pipeline, as: TestingPipeline
  alias Membrane.VideoCompositor.MultipleInputs.VideoCompositor.Implementations
  alias Membrane.VideoCompositor.Test.Pipeline.Raw.MultipleInputs, as: PipelineRaw
  alias Membrane.VideoCompositor.Utility, as: TestingUtility

  @filter_description "split[b1], pad=iw:ih*2[a1], [a1][b1]overlay=0:h, split[b2], pad=iw*2:ih[a2], [a2][b2]overlay=w:0"
  @implementation Implementations.get_all_implementations()

  @hd_video %RawVideo{
    width: 1280,
    height: 720,
    framerate: {1, 1},
    pixel_format: :I420,
    aligned: nil
  }

  Enum.map(@implementation, fn implementation ->
    describe "Checks #{implementation} composition and raw video pipeline on" do
      @describetag :tmp_dir

      test "3s 720p 1fps raw video", %{tmp_dir: tmp_dir} do
        test_raw_composing(@hd_video, 3, unquote(implementation), tmp_dir, "short_videos")
      end

      @tag long: true
      test "10s 720p 1fps raw video", %{tmp_dir: tmp_dir} do
        test_raw_composing(@hd_video, 10, unquote(implementation), tmp_dir, "long_videos")
      end
    end
  end)

  @spec test_raw_composing(Membrane.RawVideo.t(), non_neg_integer(), atom, binary(), binary()) ::
          nil
  defp test_raw_composing(video_caps, duration, implementation, tmp_dir, sub_dir_name) do
    {input_path, output_path, reference_path} =
      TestingUtility.prepare_testing_video(video_caps, duration, "raw", tmp_dir, sub_dir_name)

    :ok =
      TestingUtility.generate_raw_ffmpeg_reference(
        input_path,
        video_caps,
        reference_path,
        @filter_description
      )

    positions = [
      {0, 0},
      {video_caps.width, 0},
      {0, video_caps.height},
      {video_caps.width, video_caps.height}
    ]

    out_caps = %RawVideo{
      width: video_caps.width * 2,
      height: video_caps.height * 2,
      framerate: video_caps.framerate,
      pixel_format: video_caps.pixel_format,
      aligned: video_caps.aligned
    }

    options = %{
      paths: %{
        input_paths: for(_i <- 1..4, do: input_path),
        output_path: output_path
      },
      in_caps: video_caps,
      caps: out_caps,
      implementation: implementation,
      positions: positions
    }

    assert {:ok, pid} = TestingPipeline.start_link(module: PipelineRaw, custom_args: options)

    assert_pipeline_playback_changed(pid, _, :playing)

    assert_end_of_stream(pid, :sink, :input, 1_000_000)
    TestingPipeline.terminate(pid, blocking?: true)

    assert {:ok, out_video} = File.read(output_path)
    assert {:ok, composed_video} = File.read(reference_path)

    assert out_video == composed_video
  end
end
