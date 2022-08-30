# Benchmarks for Membrane Video Compositor Plugin

## Current benchmarks

1. Benchee (run time and memory usage benchmarks):
    - h264 pipeline benchmark ```lib\benchee\h264_pipeline.exs```
    - raw pipeline benchmark ```lib\benchee\raw_pipeline.exs```
    - merge frames benchmark ```lib\benchee\merge_frames.exs```
2. Beamchmark (reductions / context switches / cpu and memory usage / schedulers):
    - h264 pipeline benchmark ```lib\beamchmark\h264_pipeline.exs```
    - raw pipeline benchmark ```lib\beamchmark\raw_pipeline.exs```
## How to run benchmarks:

1.  Enter benchmark folder ```cd benchmark```
2.  Run ```mix deps.get``` command
3.  Run command for benchmarks:
    1. For running packs of benchmarks:
        - for all benchmarks (estimated total run time - 38min): ```mix run benchmark.exs```
        - for benchee benchmarks (estimated total run time - 32min): ```mix run benchmark.exs benchee```
        - for beamchmark benchmarks (estimated total run time - 6min): ```mix run benchmark.exs beamchmark```
    2. For running single benchmarks:
        - benchee benchmarks: 
            - for measuring frame composition performance (estimated total run time - 13min): ```mix run lib/benchee/merge_frames.exs```
            - for measuring raw pipeline performance (estimated total run time - 13min): ```mix run lib/benchee/raw_pipeline.exs```
            - for measuring h264 pipeline performance (estimated total run time - 6min): ```mix run lib/benchee/h264_pipeline.exs```
        - beamchmark benchmarks:
            - for measuring raw pipeline performance (estimated total run time - 4min): ```mix run lib/beamchmark/raw_pipeline.exs```
            - for measuring h264 pipeline performance (estimated total run time - 4min): ```mix run lib/beamchmark/h264_pipeline.exs```
4. Results will be displayed in console log and saved in html website saved at "results" directory

## How to modify test length:

1. Benchee: </br>
    - Modify parameters in ```Benchee.run()``` function:
        - ```warmup``` for time of benchmark warmup
        - ```time``` for time of pipeline performance measurement
        - ```memory_time``` for time of pipeline memory usage measurement
2. Beamchmark: </br>
    - Modify ```benchmark_duration``` parameter in ```benchmarks_options``` map.

## Example benchmarks results:
### Lenovo Legion i7-11800H, 32GB RAM, RTX 3050 Ti

<h3 align="center"> Benchee merge two frames results: </h3>

720p                       |  1080p                    |  4k
:-------------------------:|:-------------------------:|:-------------------------:
![Benchee merge two 720p frames results](assets/lenovo_i7-11800H_rtx-3050-Ti-Mobile/results_benchee_merge_frames_720p.png) | ![Benchee merge two 1080p frames results:](assets/lenovo_i7-11800H_rtx-3050-Ti-Mobile/results_benchee_merge_frames_1080p.png) | ![Benchee merge two 1080p frames results:](assets/lenovo_i7-11800H_rtx-3050-Ti-Mobile/results_benchee_merge_frames_4k.png)


<h3 align="center"> Benchee h264 pipeline results: </h3>

720p                       |  1080p
:-------------------------:|:-------------------------:
![Benchee h264 pipeline 720p 30s 30fps results](assets/lenovo_i7-11800H_rtx-3050-Ti-Mobile/results_benchee_h264_pipeline_720p_30s_30fps.png) | ![Benchee h264 pipeline ffmpeg results](assets/lenovo_i7-11800H_rtx-3050-Ti-Mobile/results_benchee_h264_pipeline_1080p_30s_30fps.png)


<h3 align="center"> Benchee raw pipeline results: </h3>

720p                       |  1080p
:-------------------------:|:-------------------------:
![Benchee raw pipeline 720p 30s 30fps results](assets/lenovo_i7-11800H_rtx-3050-Ti-Mobile/results_benchee_raw_pipeline_720p_30s_30fps.png) | ![Benchee raw pipeline ffmpeg results](assets/lenovo_i7-11800H_rtx-3050-Ti-Mobile/results_benchee_raw_pipeline_1080p_30s_30fps.png)


### MacBook Pro i5-1038NG7, 16GB RAM, Intel Iris Plus Graphics 1536 MB

<h3 align="center"> Benchee merge two frames results: </h3>

720p                       |  1080p                    |  4k
:-------------------------:|:-------------------------:|:-------------------------:
![Benchee merge two 720p frames results](assets/mac_i5-1038NG7/results_benchee_merge_frames_720p.png) | ![Benchee merge two 1080p frames results:](assets/mac_i5-1038NG7/results_benchee_merge_frames_1080p.png) | ![Benchee merge two 1080p frames results:](assets/mac_i5-1038NG7/results_benchee_merge_frames_4k.png)


<h3 align="center"> Benchee h264 pipeline results: </h3>

720p                       |  1080p
:-------------------------:|:-------------------------:
![Benchee h264 pipeline 720p 30s 30fps results](assets/mac_i5-1038NG7/results_benchee_h264_pipeline_720p_30s_30fps.png) | ![Benchee h264 pipeline ffmpeg results](assets/mac_i5-1038NG7/results_benchee_h264_pipeline_1080p_30s_30fps.png)


<h3 align="center"> Benchee raw pipeline results: </h3>

720p                       |  1080p
:-------------------------:|:-------------------------:
![Benchee raw pipeline 720p 30s 30fps results](assets/mac_i5-1038NG7/results_benchee_raw_pipeline_720p_30s_30fps.png) | ![Benchee raw pipeline ffmpeg results](assets/mac_i5-1038NG7/results_benchee_raw_pipeline_1080p_30s_30fps.png)


