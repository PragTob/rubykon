# encoding: UTF-8
module Benchmark
  module Avg

    OUTPUT_WIDTH  = 80
    LABEL_WIDTH   = 30
    PADDING       = 2
    METRICS_WIDTH = OUTPUT_WIDTH - LABEL_WIDTH

    class BenchmarkSuite

      BENCHMARK_DESCRIPTION = {
        warmup: 'Warming up...',
        time:   'Running the benchmark...'
      }

      def initialize
        @options = default_options
        @jobs = []
        @samples = {
          warmup: [],
          time:   []
        }
      end

      def config(options)
        @options.merge! options
      end

      def report(label = "", &block)
        @jobs << Job.new(label, block)
        self
      end

      def run
        puts 'Running your benchmark...'
        divider
        each_job { |job| job.run @options[:warmup], @options[:time] }
        puts 'Benchmarking finished, here are your reports...'
        puts
        puts 'Warm up results:'
        divider
        each_job { |job| puts job.warm_up_report }
        puts
        puts 'Runtime results:'
        divider
        each_job { |job| puts job.runtime_report }
        divider
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

      def each_job(&proc)
        @jobs.each &proc
      end
    end
  end
end