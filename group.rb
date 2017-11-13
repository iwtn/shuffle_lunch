require 'set'

class Group
  def initialize(max_size)
    @max_size = max_size
    @members = Set.new
  end

  def add(member)
    @members.add member unless full?
  end

  def size
    @members.size
  end

  def each
    @members.each do |member|
      yield member
    end
  end

  def members
    @members
  end

  def full?
    @members.size == @max_size
  end
end
