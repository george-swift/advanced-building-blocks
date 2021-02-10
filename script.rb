# Enumerables

module Enumerable
  def my_each
    for value in self do
      yield (value)
    end
  end

  def my_each_with_index
    i = 0

    for value in self do
      yield(value, i)
      i += 1
    end
  end

end

p [1, 2, 3].my_each { |n| puts n }
p [1, 2, 3].each { |n| puts n }
p "------"
p [1, 2, 3].my_each_with_index { |n, i| puts "index: #{i} for #{n}"}

