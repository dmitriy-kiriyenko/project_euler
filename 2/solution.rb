require 'benchmark/ips'

FIBS = Enumerator.new do |y|
  a = b = 1
  loop do
    y << a
    a, b = b, a + b
  end
end

def naive(n)
  FIBS.take_while {|i| i < n }.select { |i| i.even? }.reduce :+
end

def lazy(n)
  FIBS.lazy.select { |i| i.even? }.take_while {|i| i < n }.reduce :+
end

def smart(n)
  even_fib = Hash.new { |h, k| h[k] = (((2 + Math.sqrt(5))**k) / Math.sqrt(5)).round }

  def sum_even_fibs(x, even_fib)
    (even_fib[x] + even_fib[x+1] - 2).to_i / 4
  end

  def num_fibs_less_than(x)
    ((Math.log(x - 0.5) + 0.5*Math.log(5)) / Math.log(2 + Math.sqrt(5))).to_i
  end

  sum_even_fibs(num_fibs_less_than(n), even_fib)
end

def super_smart(n)
  a, b = 0, 2
  while b < n do
    a, b = b, 4*b + a
  end
  (a + b - 2)/4
end

N = 4*10**1000
Benchmark.ips do |x|
  x.report("naive") { naive(N) }
  x.report("lazy") { lazy(N) }   # It's faster than naive for large numbers
  x.report("smart") { smart(N) } if N < 10_000_000 # It's faster on small numbers but fails
                                                   # on large due to Infinity
  x.report("super_smart") { super_smart(N) }
end


puts super_smart(4_000_000)
