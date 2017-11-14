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
