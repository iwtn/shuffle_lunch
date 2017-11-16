require './grouping.rb'

people = (0..99).to_a.map(&:to_s)
past_set = people[0..(people.size/2 - 1)].each_slice(10).to_a
past_set += people.each_slice(10).to_a

p Grouping.by_group_size(people, past_set, 10)
p Grouping.by_member_size(people, past_set, 6)
p Grouping.by_group_size(people, past_set, 12).map(&:to_a).flatten.size
