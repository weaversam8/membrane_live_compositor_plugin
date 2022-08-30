defmodule Membrane.VideoCompositor.Benchmark.Beamchmark.H264 do
  defmodule FFmpeg do
    @behaviour Beamchmark.Scenario

    @impl true
    def run() do
      H264PipelineBeamchmark.benchmark(:ffmpeg)
    end
  end

  defmodule OpenGL_Cpp do
    @behaviour Beamchmark.Scenario

    @impl true
    def run() do
      H264PipelineBeamchmark.benchmark(:opengl_cpp)
    end
  end

  defmodule OpenGL_Rust do
    @behaviour Beamchmark.Scenario

    @impl true
    def run() do
      H264PipelineBeamchmark.benchmark(:opengl_rust)
    end
  end

  defmodule Nx do
    @behaviour Beamchmark.Scenario

    @impl true
    def run() do
      H264PipelineBeamchmark.benchmark(:nx)
    end
  end
end

defmodule H264PipelineBeamchmark do
  @moduledoc """
  H264 pipeline benchmark.
  """

  alias Membrane.RawVideo
  alias Membrane.VideoCompositor.Implementation
  alias Membrane.VideoCompositor.Utility

  @spec benchmark(Implementation.implementation_t()) :: :ok
  def benchmark(implementation) do
    caps = %RawVideo{
      width: 1280,
      height: 720,
      framerate: {30, 1},
      pixel_format: :I420,
      aligned: nil
    }

    video_duration = 30

    output_dir = "./tmp_dir"
    output_path = Path.join(output_dir, "output_#{video_duration}s_#{caps.height}p.h264")

    input_path = "./tmp_dir/input_#{video_duration}s_#{caps.height}p.h264"
    :ok = Utility.generate_testing_video(input_path, caps, video_duration)

    pipeline_init_options = %{
      paths: %{
        first_video_path: input_path,
        second_video_path: input_path,
        output_path: output_path
      },
      caps: caps,
      implementation: implementation
    }

    1..1000
    |> Stream.each(fn _i -> run_h264_pipeline(pipeline_init_options) end)
  end

  defp run_h264_pipeline(pipeline_init_options) do
    {:ok, pid} = Membrane.VideoCompositor.Benchmark.Pipeline.H264.start(pipeline_init_options)

    Process.monitor(pid)

    receive do
      {:DOWN, _ref, :process, _pid, :normal} -> :ok
    end
  end
end

benchmarks_options = %{
  benchmark_duration: 60,
  cpu_interval: 1000,
  memory_interval: 1000,
  delay: 0,
  compare?: false,
  output_dir: "./results/beamchmark/h264_pipeline_results",
}

Beamchmark.run(Membrane.VideoCompositor.Benchmark.Beamchmark.H264.FFmpeg,
  name: "H264 Pipeline Benchmark - ffmpeg",
  duration: benchmarks_options.benchmark_duration,
  cpu_interval: benchmarks_options.cpu_interval,
  memory_interval: benchmarks_options.memory_interval,
  delay: benchmarks_options.delay,
  compare?: benchmarks_options.compare?,
  output_dir: benchmarks_options.output_dir,
  formatters: [
    Beamchmark.Formatters.Console,
    {Beamchmark.Formatters.HTML,
      [output_path: Path.join(benchmarks_options.output_dir, "h264_pipeline_ffmpeg_beamchmark_results.html")]}
  ]
)

Beamchmark.run(Membrane.VideoCompositor.Benchmark.Beamchmark.H264.OpenGL_Cpp,
  name: "H264 Pipeline Benchmark - OpenGL C++",
  duration: benchmarks_options.benchmark_duration,
  cpu_interval: benchmarks_options.cpu_interval,
  memory_interval: benchmarks_options.memory_interval,
  delay: benchmarks_options.delay,
  compare?: benchmarks_options.compare?,
  output_dir: benchmarks_options.output_dir,
  formatters: [
    Beamchmark.Formatters.Console,
    {Beamchmark.Formatters.HTML,
      [output_path: Path.join(benchmarks_options.output_dir, "h264_pipeline_opengl_cpp_beamchmark_results.html")]}
  ]
)

Beamchmark.run(Membrane.VideoCompositor.Benchmark.Beamchmark.H264.OpenGL_Rust,
  name: "H264 Pipeline Benchmark - OpenGL Rust",
  duration: benchmarks_options.benchmark_duration,
  cpu_interval: benchmarks_options.cpu_interval,
  memory_interval: benchmarks_options.memory_interval,
  delay: benchmarks_options.delay,
  compare?: benchmarks_options.compare?,
  output_dir: benchmarks_options.output_dir,
  formatters: [
    Beamchmark.Formatters.Console,
    {Beamchmark.Formatters.HTML,
      [output_path: Path.join(benchmarks_options.output_dir, "h264_pipeline_opengl_rust_beamchmark_results.html")]}
  ]
)

Beamchmark.run(Membrane.VideoCompositor.Benchmark.Beamchmark.H264.Nx,
  name: "H264 Pipeline Benchmark - Nx",
  duration: benchmarks_options.benchmark_duration,
  cpu_interval: benchmarks_options.cpu_interval,
  memory_interval: benchmarks_options.memory_interval,
  delay: benchmarks_options.delay,
  compare?: benchmarks_options.compare?,
  output_dir: benchmarks_options.output_dir,
  formatters: [
    Beamchmark.Formatters.Console,
    {Beamchmark.Formatters.HTML,
      [output_path: Path.join(benchmarks_options.output_dir, "h264_pipeline_nx_beamchmark_results.html")]}
  ]
)