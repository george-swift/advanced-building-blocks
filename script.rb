# frozen_string_literal: true

# rubocop:disable Style/CaseEquality, Style/For

# Enumerables

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    for value in self do
      yield value
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0

    for value in self do
      yield(value, i)
      i += 1
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    arr = []

    for value in self do
      arr << value if yield(value)
    end
    arr
  end

  def my_all?(pattern = nil, &block)
    # 1. if a Class is given, check for class
    return my_select { |n| n.is_a? pattern }.size == size if pattern.is_a? Class

    # 2. if regexp, is given, check for coincidence
    return my_select { |n| pattern.match? n }.size == size if pattern.is_a? Regexp

    # 3. if pattern, check for equality
    return my_select { |n| pattern === n }.size == size unless pattern.nil?

    # 4. check for any nil or false value
    return my_select { |n| n.nil? || n == false }.empty? unless block_given?

    # 5. Go on with the block check
    my_select(&block).size == size
  end

  def my_any?(pattern = nil, &block)
    return my_select { |n| !n.nil? && n != false }.size.positive? unless block_given? && !pattern.nil?

    return my_select(&block).size.positive? if block_given?

    return my_any_pattern(pattern) unless pattern.nil?

    false
  end

  def my_any_pattern(pattern = nil)
    for value in self do
      return true if (value.is_a? String) && (!pattern.is_a? Integer) && (pattern.match? value)

      return true if (pattern.is_a? Class) && (value.is_a? pattern)

      return true if value === pattern
    end
  end

  def my_none?(pattern = nil, &block)
    !my_any?(pattern, &block)
  end

  def my_count(pattern = nil, &block)
    unless pattern.nil?
      arr = my_select { |n| n === pattern }
      return arr.size
    end

    if block_given?
      arr = my_select(&block)
      return arr.size
    end

    size
  end

  def my_map(proc_arg = nil)
    return to_enum(:my_map) unless block_given?

    arr = []

    for value in self do
      arr << if proc_arg.is_a? Proc
               proc_arg.call(value)
             else
               yield(value)
             end
    end

    arr
  end

  def my_inject(initial = nil, sym = nil)
    unless block_given?
      if initial.is_a? Symbol
        sym = initial
        initial = nil
      end

      initial = self[0] if initial.nil?

      1.upto(size - 1) do |i|
        initial = initial.send(sym, self[i])
      end

      return initial
    end

    memo = self[0]

    1.upto(size - 1) do |i|
      memo = yield(memo, self[i])
    end

    memo
  end

  def my_map_mod(&block)
    arr = []
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

arr = [2, 4, 6]
p arr.my_all?

# rubocop:enable Style/CaseEquality, Style/For
