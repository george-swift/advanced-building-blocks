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

  def my_map
    arr = Array.new

    for value in self do
      arr << yield(value)
    end
    arr
  end

  def my_inject(initial = nil, sym = nil, &block)

    if not block_given?
      if initial.is_a? Symbol
        sym = initial
        initial = nil
      end

      initial = self[0] if initial.nil?

      1.upto(self.size-1) do |i|
        initial = initial.send(sym, self[i])
      end

      initial
    end

    memo = self[0]

    1.upto(self.size-1) do |i|
      memo = yield(memo, self[i])
    end

    memo
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
# p "------"
# p [1, 2, 4].my_map{ |n| n * 2 }

# [1, 4, 3, 5].my_inject
# p [2, 4, 3, 5].my_inject(12, :*)
p [2, 4, 3, 5].my_inject { |sum, n| sum * n }
# p [2, 4, 3, 5].inject { |sum, n| sum * n }
