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

  def my_map(proc_arg = nil)
    arr = Array.new

    for value in self do
      if proc_arg.is_a? Proc
        arr << proc_arg.call(value)
      else
        arr << yield(value)
      end
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

      return initial
    end

    memo = self[0]

    1.upto(self.size-1) do |i|
      memo = yield(memo, self[i])
    end

    memo
  end

  def my_map_mod(&block)
    arr = Array.new
    prc = Proc.new(&block)

    for value in self do
      arr << prc.call(value)
    end
    arr
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end
