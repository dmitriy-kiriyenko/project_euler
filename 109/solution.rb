require 'benchmark'

THRESHOLD = 100

def result
  ds = ((2..40).step(2).to_a << 50)
  throws = ((0..20).to_a + ds + (3..60).step(3).to_a << 25).sort.each_with_index.to_a
  doubles = ds.sort.each_with_index.to_a

  doubles.reduce(0) { |acc1, (a, i)|
    acc1 + throws.take_while { |(b, _)| a + b < THRESHOLD }.reduce(0) { |acc2, (b, j)|
      acc2 + (throws[j..-1].index { |(c, _)| a + b + c >= THRESHOLD } || (throws.length - j))
    }.to_i
  }
end

puts Benchmark.measure {
  puts result
}
