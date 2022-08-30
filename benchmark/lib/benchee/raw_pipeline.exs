defmodule Membrane.VideoCompositor.Benchmark.Benchee.Raw do
  @moduledoc """
  Benchmark for merge frames function.
  """

  alias Membrane.RawVideo
  alias Membrane.VideoCompositor.Utility

  @spec benchmark() :: :ok
  def benchmark() do
    report_output_dir = "./results/benchee/raw_pipeline_results"

    video_duration = 30

    output_dir = "./tmp_dir"
    output_path_720p = Path.join(output_dir, "output_60s_1280x1440.raw")
    output_path_1080p = Path.join(output_dir, "output_60s_1920x2160.raw")

    caps_720p = %RawVideo{
      width: 1280,
      height: 720,
      framerate: {30, 1},
      pixel_format: :I420,
      aligned: nil
    }

    caps_1080p = %RawVideo{
      width: 1920,
      height: 1080,
      framerate: {30, 1},
      pixel_format: :I420,
      aligned: nil
    }

    input_path_720p = "./tmp_dir/input_#{video_duration}s_720p.raw"
    input_path_1080p = "./tmp_dir/input_#{video_duration}s_1080p.raw"

    :ok = Utility.generate_testing_video(input_path_720p, caps_720p, video_duration)
    :ok = Utility.generate_testing_video(input_path_1080p, caps_1080p, video_duration)

    options_720p = %{
      paths: %{
        first_video_path: input_path_720p,
        second_video_path: input_path_720p,
        output_path: output_path_720p
      },
      caps: caps_720p,
      implementation: nil
    }

    options_1080p = %{
      paths: %{
        first_video_path: input_path_1080p,
        second_video_path: input_path_1080p,
        output_path: output_path_1080p
      },
      caps: caps_1080p,
      implementation: nil
    }


    Benchee.run(
      %{
        "FFmpeg - Two videos into one raw pipeline benchmark" =>
          fn options -> run_raw_pipeline(%{options | implementation: :ffmpeg}) end,
        "OpenGL C++ - Two videos into one raw pipeline benchmark" =>
          fn options -> run_raw_pipeline(%{options | implementation: :opengl_cpp}) end,
        "OpenGL Rust - Two videos into one raw pipeline benchmark" =>
          fn options -> run_raw_pipeline(%{options | implementation: :opengl_rust}) end,
        "Nx - Two videos into one raw pipeline benchmark" =>
          fn options -> run_raw_pipeline(%{options | implementation: :nx}) end
      },
      inputs: %{
        "1. 720p #{video_duration}s 30fps" => options_720p,
        "2. 1080p #{video_duration}s 30fps" => options_1080p
      },
      title: "Raw pipeline benchmark",
      parallel: 1,
      warmup: 2,
      time: 90,
      memory_time: 2,
      formatters: [
        {Benchee.Formatters.HTML, file: Path.join(report_output_dir, "raw_pipeline_benchmark.html")},
        Benchee.Formatters.Console
      ]
    )

    File.rm(input_path_720p)
    File.rm(input_path_1080p)
    File.rm(output_path_720p)
    File.rm(output_path_1080p)
    :ok
  end

  defp run_raw_pipeline(options) do
    {:ok, pid} = Membrane.VideoCompositor.Benchmark.Pipeline.Raw.start(options)

    Process.monitor(pid)

    receive do
      {:DOWN, _ref, :process, _pid, :normal} -> :ok
    end
  end
end

Membrane.VideoCompositor.Benchmark.Benchee.Raw.benchmark()