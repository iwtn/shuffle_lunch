require 'set'

class Set
  def pairs
    Set.new(self.map do |i1|
      self.map do |i2|
        Set[i1, i2] if i1 != i2
      end.compact
    end.flatten)
  end
end

class Grouping
  MAX_AMOUNT = 2 ** ([42].pack('i').size * 16 - 2) - 1

  private_class_method :new

  def self.by_group_size(people, past_set, group_size)
    new(people, past_set, group_size).execute
  end

  def self.by_member_size(people, past_set, max_member_size)
    group_size = people.size / max_member_size
    new(people, past_set, group_size).execute
  end

  def execute
    links = make_heuristic_from_past(@past_set)
    link_amount_hash = make_link_amount_hash(@people, links)

    groups = {}
    @group_size.times { |i| groups[i] = Set.new }

    link_amount_hash.sort {|a, b| b[1]<=>a[1]}.map{|k, v| k }.each do |person|
      group = select_group(groups, person, links)
      groups[group].add person
    end

    groups.values
  end

  private

  def initialize(people, past_set, group_size)
    @people = people
    @past_set = past_set
    @group_size = group_size
    @max_member_size = people.size / group_size
  end

  def make_heuristic_from_past(past_set)
    past_pheromone = Hash.new(0)
    past_set.each do |past|
      past.each do |sets|
        sets.each do |set|
          set.pairs.each do |pair|
            past_pheromone[pair] += 1
          end
        end
      end
    end
    past_pheromone
  end

  def make_link_amount_hash(people, links)
    hash = {}
    people.each do |person|
      amount = 0
      links.each do |pair, value|
        amount += value if pair.member? person
      end
      hash[person] = amount
    end
    hash
  end

  def select_group(groups, person, links)
    group_amounts = {}
    groups.each do |k, s|
      if s.size >= @max_member_size
        group_amounts[k] = MAX_AMOUNT
      else
        amount = 0
        s.each do |member|
          amount += links[Set[member, person]].to_i
        end
        group_amounts[k] = amount
      end
    end
    group_amounts.min{ |x, y| x[1] <=> y[1] }[0]
  end
end
