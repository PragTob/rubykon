require_relative 'avg/benchmark_suite'

module Benchmark
  module Avg
    def avg
      benchmark_suite = BenchmarkSuite.new

      yield benchmark_suite

      [:warmup, :time].each do |type|
        benchmark_suite.run type
      end

      benchmark_suite.report
    end
  end

  extend Benchmark::Avg
end