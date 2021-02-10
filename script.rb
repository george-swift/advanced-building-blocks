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

  def my_all?(&block)
    new_arr = self.my_select(&block)

    return new_arr.size == self.size ? true : false
  end

  def my_any?(pattern = nil, &block)
    if block_given?
      new_arr = self.my_select(&block)
      return new_arr.size > 0 ? true : false
    end
    
    if !pattern.nil?
      for value in self do
        if value.is_a? String and !pattern.is_a? Integer
          return true if pattern.match? value
        end

        if pattern.is_a? Class
          return true if value.is_a? pattern
        else 
          return true if value === pattern
        end
      end
    end
    
    return false
  end

  def my_none?(pattern = nil, &block)
    return !self.my_any?(pattern, &block)
  end

  def my_count(pattern = nil, &block)
    if !pattern.nil?
      arr = self.my_select { |n| n === pattern }
      return arr.size
    end

    if block_given?
      arr = self.my_select(&block)
      return arr.size
    end

    return self.size
  end
end

# p [1, 2, 3].my_each { |n| puts n }
# p "------"
# p [1, 2, 3].my_each_with_index { |n, i| puts "index: #{i} for #{n}"}
# p "------"
# p [1, 2, 3, 4, 5].my_select { |n| n.odd? }
# p "------"
# p [1, 3, 5].my_all? { |n| n.odd? }
# p "------"
# p [1, 2, 'abcd'].my_any?(2)
# p [1, 3, 'abcd'].my_none?(/d/)
# p [3, 2, 4, 2].my_count(3) { |n| n / 2 == 2 }
