# frozen_string_literal: true

# Creating my own enumerables in this module
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?
    hash_to_a = self.to_a if self.class == Hash
    case self
    in Array then size.times { |idx| yield(self[idx]) }
    in Hash then hash_to_a.size.times { |idx| yield(hash_to_a[idx]) }
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each) unless block_given?
    case self
    in Array then size.times { |idx| yield(self[idx], idx) }
    end
    self
  end

  def my_select
    return to_enum(:my_each) unless block_given?
    new_array = []
    self.my_each do |item|
      new_array << item if yield(item)
    end
    new_array
  end

  def my_all?
    arr = []
    return to_enum(:my_each) unless block_given?
    self.my_select { |item| arr << item if yield(item)}.size == self.size
  end

  def my_any?
    return to_enum(:my_each) unless block_given?
    arr = []
    self.my_select { |item| arr << item if yield(item)}.size > 0
  end

  def my_none?
    return to_enum(:my_each) unless block_given?
    arr = []
    self.my_select { |item| arr << item if yield(item)}.size == 0
  end

  def my_count(*args)
    arr = to_a if instance_of?(Range)
    arr = self if instance_of?(Array)

    if !block_given? && args[0].nil?
      counter = 0
      counter += 1 while counter < arr.length
      counter
    elsif !block_given? && !args[0].nil?
      count = 0
      section = 0
      while count < length
        section += 1 if arr[count] == args[0]
        count += 1
      end
      section
    elsif block_given? && args[0].nil?
      num = 0
      ematch = 0
      while num < length
        ematch += 1 if yield(arr[num])
        num += 1
      end
      ematch
    end
  end

  def my_map
    new_arr = []
    self.my_each { |element| new_arr << yield(element) }
    new_arr
  end

  def my_inject(acc = (arg_not_passed = true; self[0]))
    acc == self[0] && arg_not_passed ? arr = self[1..-1] :  arr = self
    arr.my_each {|element| acc = yield(acc, element)}
    acc
  end

  def my_map_with_proc(proc_method)
    new_arr = []
    self.my_each { |element| new_arr << proc_method.call(element) }
    new_arr
  end

  def my_map_with_proc_or_block(arg = nil)
    new_arr = []
    self.my_each { |element| new_arr << arg.call(element) } unless arg.nil?
    self.my_each { |element| new_arr << yield(element) } if arg.nil?
    new_arr
  end
end

# # 1: Script 1: each
# puts 'my_each vs. each'
# numbers = [1, 2, 3, 4, 5]
# numbers.my_each  { |item| puts item }
# numbers.each  { |item| puts item }

# # with hash
# my_hash = {a: 1, b: 2}
# my_hash.each { |key, value| puts key, value}
# my_hash.my_each { |key, value| puts key, value }


# #2: Script 2: each_with_index

# puts 'my_each_with_index vs each_with_index'
# numbers = [1, 2, 3, 4, 5]
# numbers.each_with_index { |value, index| puts "#{index}: #{value}"}
# numbers.my_each_with_index { |value, index| puts "#{index}: #{value}"}


# 3: Script 3:
# puts 'my_select vs select'
# numbers = [1, 2, 3, 4, 5]
# puts numbers.select { |number| number > 3 }
# puts numbers.my_select { |number| number > 3 }

# 4: Script 4:
# puts 'my_all? vs all?'
# numbers = [1, 2, 3, 4, 5,8]
# puts numbers.all? { |el| el < 6 }
# puts numbers.my_all? { |el| el < 6 }

# 5: Script 5:
# puts 'my_any? vs any?'
# numbers = [1, 2, 3, 4, 5, 9]
# puts numbers.any? { |el| el > 8 }
# puts numbers.my_any? { |el| el > 8 }

# 6: Script 6:
# puts 'my_none? vs none?'
# numbers = [5, 3, 4, 9]
# puts numbers.none? { |el| el > 8 }
# puts numbers.my_none? { |el| el > 8 }

# 7: Script 7:
# puts 'my_none? vs none?'
# numbers = [5, 3, 4, 9]
# puts numbers.none? { |el| el > 8 }
# puts numbers.my_none? { |el| el > 8 }

# 8: Script 8:
# puts 'my_count? vs count?'
# numbers = [5, 3, 4, 9]
# puts numbers.count(10)
# puts numbers.my_count(10)

#9: Script 9:
# puts 'my_map vs map'
# items = [1, 2, 3, 4, 5]
# p items.map { |element| element ** 2}
# new_arr = items.my_map { |element| element ** 2 }
# p new_arr

# def multiply_els(num_arr)
#   num_arr.my_inject { |product, num| product * num }
# end

# #10: Script 10:
# puts 'my_inject vs inject'
# numbers = [4, 1, 2, 4]
# puts numbers.inject() { |ac, el| ac * el}
# puts numbers.my_inject { |ac, el| ac * el}
# puts multiply_els(numbers)

# 11: Proc
# puts 'sending a proc to map'
# my_proc = Proc.new { |number| number * 2 }
# numbers = [1, 2, 3, 4, 5]
# p numbers.my_map_with_proc(my_proc)


# # 12: Proc or block
# # puts 'sending a proc to map'
# my_proc = Proc.new { |number| number * 2 }
# # numbers = [1, 2, 3, 4, 5]
# numbers = [1, 2, 3, 4, 5]
# p numbers.my_map_with_proc(my_proc)
# p numbers.my_map_with_proc_or_block(my_proc)
# p numbers.my_map_with_proc_or_block { |number| number * 2 }
