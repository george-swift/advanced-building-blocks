# Enumerables

module Enumerable
  def my_each
    for value in self do
      yield (value)
    end
  end

end

p [1, 2, 3].my_each { |n| puts n }

p [1, 2, 3].each { |n| puts n }