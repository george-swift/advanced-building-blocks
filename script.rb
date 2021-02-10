# rubocop:disable Style/CaseEquality, Style/For
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

# Enumerables

module Enumerable
  def my_each
    for value in self do
      yield value
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
    arr = []

    for value in self do
      arr << value if yield(value)
    end
    arr
  end

  def my_all?(&block)
    new_arr = my_select(&block)

    new_arr.size == size
  end

  def my_any?(pattern = nil, &block)
    if block_given?
      new_arr = my_select(&block)
      return new_arr.size.positive?
    end

    unless pattern.nil?
      for value in self do
        return true if (value.is_a? String) && (!pattern.is_a? Integer) && (pattern.match? value)

        return true if (pattern.is_a? Class) && (value.is_a? pattern)

        return true if value === pattern
      end
    end

    false
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

# rubocop:enable Style/CaseEquality, Style/For
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
