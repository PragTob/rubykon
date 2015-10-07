require_relative '../lib/rubykon'
require_relative 'support'

def truffle? # truffle can't do gem install
  defined?(RUBY_DESCRIPTION) && RUBY_DESCRIPTION.match(/graal/)
end

if truffle?
  embedded_path = File.expand_path('benchmark-ips/lib/', File.dirname(__FILE__))
  $LOAD_PATH << embedded_path
end

require 'benchmark/ips'

Benchmark.ips do |benchmark|
  benchmark.config time: 20, warmup: 5

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