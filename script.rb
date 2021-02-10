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

  def my_select
    arr = Array.new
    for value in self do
      if yield(value)
        arr << value
      end
    end
    arr
  end

end

p [1, 2, 3].my_each { |n| puts n }
p [1, 2, 3].each { |n| puts n }
p "------"
p [1, 2, 3].my_each_with_index { |n, i| puts "index: #{i} for #{n}"}
p "------"
p [1, 2, 3, 4, 5].my_select { |n| n.odd? }





