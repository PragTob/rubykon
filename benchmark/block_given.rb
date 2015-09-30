require_relative '../lib/rubykon'
require 'benchmark/ips'

def foo
  if block_given?
    yield 14, 2
  else
    14 + 2
  end
end

Benchmark.ips do |benchmark|
  benchmark.config time: 30, warmup: 60

  benchmark.report 'b_g? with block' do
    foo do |a, b|
      a + b
    end
  end

  benchmark.report 'b_g? without block' do
    foo
  end
  
end
