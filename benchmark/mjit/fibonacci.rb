require_relative '../../lib/benchmark/avg'

def fib n
  if n < 3
    1
  else
    fib(n-1) + fib(n-2)
  end
end

Benchmark.avg do |benchmark|
  benchmark.config time: 20, warmup: 10

  benchmark.report "fib(30)" do
    fib(30)
  end
end
