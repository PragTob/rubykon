require_relative '../lib/rubykon'
require_relative 'support/playout_help'
require_relative 'support/benchmark-ips'

Benchmark.ips do |benchmark|
  benchmark.config time: 30, warmup: 60

  benchmark.report '9x9 full playout (+ score)' do
    full_playout_for 9
  end
  benchmark.report '13x13 full playout (+ score)' do
    full_playout_for 13
  end
  benchmark.report '19x19 full playout (+ score)' do
    full_playout_for 19
  end
end