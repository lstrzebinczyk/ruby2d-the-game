require "benchmark/ips"

Benchmark.ips do |x|
  x.report("native hour") do
    Time.new.hour
  end

  x.report "new hour" do 
    ((Time.now.to_i % 86400) / 3600).floor + 1
  end

  x.compare!
end
