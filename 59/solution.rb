require 'benchmark'

PASS_SIZE = 3
PASS_CHARS = ('a'.ord..'z'.ord)
GOOD_CHARS = (' '.ord..'z'.ord)

def result
  input = File.read(File.expand_path("input.txt", File.dirname(__FILE__))).chomp.split(",").map(&:to_i)
  piece, *pieces = input.each_slice(PASS_SIZE).to_a

  pass_range = piece.zip(*pieces).map { |slice|
    PASS_CHARS.select { |ch|
      slice.compact.uniq.all? { |l| GOOD_CHARS.include? l^ch }
    }
  }

  passwords = pass_range.reduce { |acc, i| acc.product(i).map(&:flatten) }.map
  texts = passwords.lazy.map { |pass| input.zip(pass.cycle).map { |(c, d)| c^d } }
  best = texts.detect { |text| text.map(&:chr).join.include?('the') }
  best.reduce :+
end

puts Benchmark.measure {
  puts result
}
