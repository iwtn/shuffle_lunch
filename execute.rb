require './grouping.rb'

people = (0..99).to_a.map(&:to_s)
past_set = [
  [ people[0..(people.size/2 - 1)].each_slice(10).map{|ten_persons| Set.new(ten_persons)} ],
  [ people.each_slice(10).map{|ten_persons| Set.new(ten_persons)} ],
]

p Grouping.new(people, past_set, 10).execute
