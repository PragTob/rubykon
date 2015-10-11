# encoding: UTF-8
module Benchmark
  module Avg
    class BenchmarkSuite
      OUTPUT_WIDTH = 80
      PRECISION    = 2
      BENCHMARK_DESCRIPTION = {
        warmup: 'Warming up...',
        time:   'Running the benchmark...'
      }

      def initialize
        @options = default_options
        @list = []
      end

      def config(options)
        @options.merge! options
      end

      def report(label = "", &blk)
        @list << [label, blk]
        self
      end

      def run(type)
        puts BENCHMARK_DESCRIPTION[type]
        divider
        time = @options[type]
        run_benchmarks(time)
        puts
      end

      private
      def default_options
        {
          warmup: 30,
          time: 60,
          min_iterations: 2
        }
      end

      def divider
        puts '-' * OUTPUT_WIDTH
      end

      def run_benchmarks(time)
        @list.each do |label, to_benchmark|
          run_and_measure(label, to_benchmark, time)
        end
      end

      def run_and_measure(label, to_benchmark, time)
        suite_finish      = Time.now + time
        samples = []

        while Time.now < suite_finish
          measure_block(samples, to_benchmark)
        end

        print_results label, samples
      end

      def measure_block(samples, to_benchmark)
        start = Time.now
        to_benchmark.call
        finish = Time.now
        samples << (finish - start)
      end

      def extract_times(samples)
        times         = {}
        times[:total] = samples.inject(:+)
        iterations    = samples.size
        times[:avg]   = times[:total] / iterations
        times[:ipm]   = iterations / (times[:total] / 60)
        total_variane = samples.inject(0) do |total, time|
          total + ((time - times[:avg]) ** 2)
        end
        times[:variance] = total_variane / iterations
        times[:standard_deviation] = Math.sqrt times[:variance]
        times[:standard_deviation_percent] = 100.0 * (times[:standard_deviation] / times[:avg])
        times
      end


      def print_results(label, samples)
        p samples
        times = extract_times(samples)
        print label.ljust(28) + ' ' * 2
        puts "#{times[:ipm].round(PRECISION)} i/min  #{times[:avg].round(PRECISION)} s (avg) (± #{times[:standard_deviation_percent].round(PRECISION)
        }%)"
      end
    end
  end
end