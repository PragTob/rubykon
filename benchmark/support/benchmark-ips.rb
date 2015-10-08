def truffle? # truffle can't do gem install
  defined?(RUBY_DESCRIPTION) && RUBY_DESCRIPTION.match(/graal/)
end

require 'benchmark/ips'

# only loaded for truffle normally, as it has little to
# no effect on other implementations I tested.
# If I publish benchmark results, I'll let all
# implementations run with this for fairness' sake :)
if truffle?
  require_relative 'benchmark-ips_shim'
end