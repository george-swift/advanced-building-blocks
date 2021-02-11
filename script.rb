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
    # 1. if a class is given, so much as one return true
    return my_select { |n| n.is_a? pattern }.size.positive? if pattern.is_a? Class

    # 2 when regex is given match one say true
    return my_select { |n| pattern.match? n }.size.positive? if pattern.is_a? Regexp

    # 3 if pattern is not class or regex, check equality
    return my_select { |n| pattern === n }.size.positive? unless pattern.nil?

    # 4 check for falsy value if no block is given
    # rubocop:disable Style/DoubleNegation
    return my_select { |n| !!n }.size.positive? unless block_given?

    # rubocop:enable Style/DoubleNegation

    my_select(&block).size.positive?
  end

  def my_none?(pattern = nil, &block)
    # 1. no block and no argument is given
    return my_select { |n| [false, nil].include?(n) }.size == size if !block_given? && pattern.nil?

    # 2. opposite of any
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
    values = is_a? Range ? to_a : self

    unless block_given?
      if initial.is_a? Symbol
        sym = initial
        initial = nil
      end

      initial = values[0] if initial.nil?

      1.upto(size - 1) do |i|
        initial = initial.send(sym, values[i])
      end

      return initial
    end

    memo = values[0]

    1.upto(size - 1) do |i|
      memo = yield(memo, values[i])
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

# rubocop:enable Style/CaseEquality, Style/For
