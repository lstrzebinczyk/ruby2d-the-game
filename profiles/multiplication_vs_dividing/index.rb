require "benchmark/ips"

Benchmark.ips do |x|
  x.report "multiplication" do
    15.0 * 1.736e-05
  end

  x.report("dividing") do
    15.0 / 57600.0
  end

  x.compare!
end
