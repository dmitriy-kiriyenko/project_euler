input = File.read(File.expand_path("input.txt", File.dirname(__FILE__))).chomp.split(",").map(&:to_i)
keys = ('a'.ord..'z'.ord).to_a.combination(3).flat_map { |k| k.permutation.to_a }
decrypts = keys.lazy.map { |key| input.zip(key.cycle).map { |(c, d)| c^d} }
first, last = ' '.ord, 'z'.ord
good_decrypts = decrypts.select { |decrypt| decrypt.all? { |c| first <= c && c <= last } }
puts good_decrypts.detect { |decrypt| decrypt.map(&:chr).join.include?('the') }.reduce :+
