module Benchmark
  module Avg
    class Job

      PRECISION    = 2

      def initialize(label, block)
        @label          = label
        @block          = block
        @warmup_samples = []
        @run_samples    = []
        @warming_up     = true
      end

      def run(warm_up_time, run_time)
        warm_up_finish = Time.now + warm_up_time
        measure_until(@warmup_samples, warm_up_finish)
        finish_warmup

        suite_finish = Time.now + run_time
        measure_until(@run_samples, suite_finish)
      end


      def warm_up_report
        report @warmup_samples
      end

      def runtime_report
        report @run_samples
      end

      private
      def measure_until(samples, warm_up_finish)
        while Time.now < warm_up_finish do
          measure_block(samples)
        end
      end

      def measure_block(samples)
        start = Time.now
        @block.call
        finish = Time.now
        samples << (finish - start)
      end

      def finish_warmup
        @warming_up = false
        puts "Finished warm up for #{@label}, running the real bechmarks now"
      end

      def report(samples)
        times = extract_times(samples)
        label = @label.ljust(28) + ' ' * 2
        time = "#{times[:ipm].round(PRECISION)} i/min  #{times[:avg].round(PRECISION)} s (avg) (± #{times[:standard_deviation_percent].round(PRECISION)}%)"
        label + time
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
    end
  end
end