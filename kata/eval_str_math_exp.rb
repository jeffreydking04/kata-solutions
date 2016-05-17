def evaluate(str)
puts "start of evaluate str = #{str}"
# declare boolean array to indicate presence of operators
# 0 = div, 1 = mult, 2 = add, 3 = sub, 4 = operators present
  flag_array = [false,false,false,false,true]
# check to be sure an operation is in the string
  flag_array[4] = false if !str.include?('/') && !str.include?('*') and !str.include?('+') and !str.include?('-')
  return str if !flag_array[4] && str[0] == 'N'
# while operators are present
  if flag_array[4]
# set flags for first order operators
    if str.include?('/')
      division_index = str.index('/')
      flag_array[0] = true
    end
    if str.include?('*')
      multiplication_index = str.index('*')
      flag_array[1] = true
    end
# find initial first order operator
    operator_index = division_index if flag_array[0]
    operator_index = multiplication_index if flag_array[1] 
    operator_index = [division_index, multiplication_index].min if flag_array[0] && flag_array[1]
# call evaluation: arithmetic (str, flag_array, operator_index)
# returns string edited with evaluation replacing expressionputs "#{str}"
    str = arithmetic(str, flag_array, operator_index) if flag_array[0] || flag_array[1]
# recursively call evaluate(str) to catch more first order ops
puts "#{str}"
    (str = evaluate(str)) if str.to_s.include?('/') || str.to_s.include?('*')
# set flags for second order operators
    if str.to_s.include?('+')
      addition_index = str.index('+')
      flag_array[2] = true
    end
    if str.to_s.include?('-')
    subtraction_index = str.index('-')
      flag_array[3] = true
    end
# find initial second order operator
    operator_index = addition_index if flag_array[2]
    operator_index = subtraction_index if flag_array[3] 
    operator_index = [addition_index, subtraction_index].min if flag_array[2] && flag_array[3]
# call evaluation: arithmetic (str, flag_array, operator_index)
# returns string edited with evaluation replacing expression
    str = arithmetic(str, flag_array, operator_index) if flag_array[2] || flag_array[3]
# recursively call evaluate(str) to catch more second order ops
print "#{str}  #{str.is_a?String}"
    (str = evaluate(str)) if str.to_s.include?('+') || str.to_s.include?('-')
  end
# return string
  str
end

def arithmetic (str, f_array, o_index)
# set array for opertions
  operator_array = %w{/ * + -}
# get substring to left of operator after previous operator
  left_sub_string = str[0...o_index]
  rev_left = left_sub_string.reverse
  sub_string_contain_operator = false
  sub_string_contain_operator = true if operator_array.any? { |w| rev_left[w] }
  if sub_string_contain_operator
    d_i = rev_left.index('/') if rev_left.include?('/')
    m_i = rev_left.index('*') if rev_left.include?('*')
    a_i = rev_left.index('+') if rev_left.include?('+')
    s_i = rev_left.index('-') if rev_left.include?('-')
    left_ind = [d_i, m_i, a_i, s_i]
    left_ind.delete(nil)
    left_ind = rev_left.length - left_ind.min + 1
  else
    left_ind = 0
  end
  left_number_string = str[left_ind...o_index]
  neg_flag = false
  neg_flag = true if left_number_string.include?('N')  
  left_number_string.delete!('N') if left_number_string.include?('N')
  left_number_string.include?('.') ? left_number_numeric = left_number_string.to_f : left_number_numeric = left_number_string.to_i
  left_number_numeric *= (-1) if neg_flag
# get substring to right of operator before next operator
  right_sub_string = str[o_index+1..-1]
  sub_string_contain_operator = false
  sub_string_contain_operator = true if operator_array.any? { |w| right_sub_string[w] }
  if sub_string_contain_operator
    d_i = right_sub_string.index('/') if right_sub_string.include?('/')
    m_i = right_sub_string.index('*') if right_sub_string.include?('*')
    a_i = right_sub_string.index('+') if right_sub_string.include?('+')
    s_i = right_sub_string.index('-') if right_sub_string.include?('-')
    right_ind = [d_i, m_i, a_i, s_i]
    right_ind.delete(nil)
    right_ind = right_ind.min
  else 
    right_ind = right_sub_string.length
  end
  right_number_string = right_sub_string[0...right_ind]
  neg_flag = false
  neg_flag = true if right_number_string.include?('N')
  right_number_string.delete!('N') if right_number_string.include?('N')
  right_number_string.include?('.') ? right_number_numeric = right_number_string.to_f : right_number_numeric = right_number_string.to_i
  left_number_numeric *= (-1) if neg_flag  
# evaluate string

  ans = (left_number_numeric / right_number_numeric) if str[o_index] == '/'
  ans = (left_number_numeric * right_number_numeric) if str[o_index] == '*'
  ans = (left_number_numeric + right_number_numeric) if str[o_index] == '+'
  ans = (left_number_numeric - right_number_numeric) if str[o_index] == '-'
  if ans < 0
     ans = (ans * (-1)).to_s
     reduced_str = ans.insert(0, 'N')
   else
    print ans.to_s
    puts ""
     reduced_str = ans.to_s
     print "#{reduced_str}"
  end
# replace expression with evalutation in string
  if left_number_string + str[o_index] + right_number_string == str
    reduced_str = ans
  else
    if left_ind != 0   
      reduced_str = str[0...left_ind] + ans + str[o_index+right_ind+1..-1]
    end 
  end
# return str
  reduced_str
end

def find_paren_endices(str, i_array)
# find index of character before first ")"
  i_array[1] = str.index(')') - 1
# find index of character after first "("
# take substring to previous index, reverse, look for first
# index of "(", but string is reversed so subtract from
# substring length to get index of the string forward
# add 1 to get the character after the "("
  i_array[0] = i_array[1] - str[0..i_array[1]].reverse.index('(') + 1
#return array
  i_array
end

def calc(str)
  numbers = %w{0 1 2 3 4 5 6 7 8 9}
  ops = %w{/ * + )}
# locate all '-'
  str.gsub!('-', 'N') if str.include?('-')
# eliminate all whitespace
  str.delete! " "
# differentiate between minus and negative
  (1...str.length).each do |i|
      str[i] = '-' if str[i+1] == 'N' && str[i] == 'N'   
      str[i] = '-' if str[i] == 'N' && ops.include?(str[i-1])
      str[i] = '-' if str[i] == 'N' && numbers.include?(str[i-1]) && (numbers.include?(str[i+1]) || str[i+1] == '.')
    end

# declare an array to hold index pairs
  index_pairs = Array.new(2)
# determine if string has parens (while str.include?("("))
  if !str.include?(')')
    str = evaluate(str)
  else  
    while str.include?(")")
# if yes (find__paren_endices)
      index_pairs = find_paren_endices(str, index_pairs)
# evaluate(substring)
      evaluated_str = evaluate(str[index_pairs[0]..index_pairs[1]])
      str = str[0...index_pairs[0]-1] + evaluated_str.to_s + str[index_pairs[1]+2..-1]
    end
  end

  n_flag = false
  if str.to_s.include?('N')
    str.delete!('N')
    n_flag = true
  end
  if str.to_s.include?('.')
    answer = str.to_f
  else
    answer = str.to_i
  end
  answer *= (-1) if n_flag
  answer
end
puts calc('2.5 + 2')
puts calc('2 /2+3 * 4.75- -6')
puts calc('12* 123')
puts calc('2 / (2 + 3) * 4.33 - -6')