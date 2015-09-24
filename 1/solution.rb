require 'benchmark/ips'

def reference(n1, n2, limit)
  (1...limit).select { |x| x%n1==0 || x%n2==0 }.reduce :+
end

# This only works for comprime integers
# For non-comprime instead of product here should be LCM
def hacky(n1, n2, limit)
  [n1,n2,-n1*n2].map{|i, n| n = (limit-1)/i; i*n*(n+1)/2 }.reduce(:+)
end

def correct(n1, n2, limit)
  [n1,n2,-(n1.lcm(n2))].map{|i, n| n = (limit-1)/i; i*n*(n+1)/2 }.reduce(:+)
end

def smart(n1, n2, limit)
  p1 = n1*n2
  (1..p1).select { |x| x%n1==0 || x%n2==0 }.map { |x|
    p2=(limit-x-1)/p1
    (x+x+p1*p2)*(p2+1)
  }.reduce(:+)/2
end

Benchmark.ips do |x|
  x.report("reference") { reference(3, 5, 1000) }
  x.report("hacky") { hacky(3, 5, 1000) }
  x.report("correct") { correct(3, 5, 1000) }
  x.report("smart") { smart(3, 5, 1000) }
end

puts smart(3, 5, 1000)
