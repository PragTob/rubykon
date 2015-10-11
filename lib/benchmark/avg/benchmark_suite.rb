module Benchmark
  module Avg
    class BenchmarkSuite
      def initialize
        @options = default_options
        @list = []
      end

      def configure(options)
        @options.merge! options
      end

      def report(label = "", &blk)
        @list << [label, blk]
        self
      end

      def run_warmup
        puts 'warming up'
        @list.each do |label, to_benchmark|
          run_and_measure(label, to_benchmark, warmup_time)
        end
      end

      def run
        puts 'running'
        @list.each do |label, to_benchmark|
          run_and_measure(label, to_benchmark, run_time)
        end
      end

      private
      def default_options
        {
          warmup: 30,
          time: 60,
          min_iterations: 2
        }
      end

      def warmup_time
        @options[:warmup]
      end

      def run_time
        @options[:time]
      end

      def run_and_measure(label, to_benchmark, time)
        iter = 0
        start       = Time.now
        finish      = start + time

        while Time.now < finish
          to_benchmark.call
          iter += 1
          puts "Iteration: #{iter}"
        end

        finished = Time.now
        run_time = finished - start

        puts "#{label} took #{run_time} seconds to do #{iter} iterations"
        puts "one iteration took #{run_time/iter} seconds on average"
        puts "Or #{iter/ (run_time/ 60)} iterations per minute"
      end
    end
  end
end