require 'open-uri'

VALUES = Hash['23456789TJQKA'.chars.each_with_index.map {|v, i| [v, i+2]}]
STRAIGHTS = (5..14).step(1).map {|x| [x, x-1, x-2, x-3, x-4]} << [14, 5, 4, 3, 2]
RANKS = [[1,1,1,1,1],[2,1,1,1],[2,2,1],[3,1,1],[],[],[3,2],[4,1]]

def rank(hand)
  set, values = hand.group_by { |x| x[0]}.map {|(v, l)| [l.size, VALUES[v]]}.sort.reverse.transpose
  combo = RANKS.index(set)
  combo = 5 if hand.uniq {|x| x[1]}.size == 1
  combo = (combo == 5 ? 8 : 4) if STRAIGHTS.include?(values)
  [combo, values]
end

open("https://projecteuler.net/project/resources/p054_poker.txt") { |f|
  puts f.each_line.reduce(0) { |acc, i|
    i = i.split(" ")
    acc + ((rank(i.take(5)) <=> rank(i.drop(5))) > 0 ? 1 : 0)
  }
}
