def evaluate(str)
# declare boolean array to indicate presence of operators
# 0 = div, 1 = mult, 2 = add, 3 = sub, 4 = operators present
  flag_array = [false,false,false,false,true]
# check to be sure an operation is in the string
puts "evaluate beginning #{str}!"
  flag_array[4] = false if !str.include?('/') && !str.include?('*') and !str.include?('+') and !str.include?('-') 
# while operators are present
  while flag_array[4]
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
    operator index = division_index if flag_array[0]
    operator_index = multiplication_index if flag_array[1] 
    operator_index = [division_index, multiplication_index].min if flag_array[0] && flag_array[1]
# call evaluation: arithmetic (str, flag_array, operator_index)
# returns string edited with evaluation replacing expression
    str = arithmetic(str, flag_array, operator_index)
    puts "#{str}"
# recursively call evaluate(str) to catch more first order ops
    str = evaluate(str)
# set flags for second order operators
    if str.include?('+')
      addition_index = str.index('+')
      flag_array[2] = true
    end
    if str.include?('-')
    subtraction_index = str.index('-')
      flag_array[3] = true
    end
# find initial second order operator
    operator index = addition_index if flag_array[2]
    operator_index = subtraction_index if flag_array[3] 
    operator_index = [addition_index, subtraction_index].min if flag_array[2] && flag_array[3]
# call evaluation: arithmetic (str, flag_array, operator_index)
# returns string edited with evaluation replacing expression
    str = arithmetic(str, flag_array, operator_index)
# recursively call evaluate(str) to catch more second order ops
    evaluate(str)
  end
# return string
puts "#{str}"
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
    d_i = rev_left.index('/') if rev_left.include('/')
    m_i = rev_left.index('*') if rev_left.include('*')
    a_i = rev_left.index('+') if rev_left.include('+')
    s_i = rev_left.index('-') if rev_left.include('-')
    left_ind = rev_left.length - [d_i, m_i, a_i, s_i].min + 1
  else
    left_ind = 0
  end
  left_number_string = str[left_ind...o_index]
  left_number_string.include?('.') ? left_number_numeric = left_number_string.to_f : left_number_numeric = left_number_string.to_i
# get substring to right of operator before next operator
  right_sub_string = str[o_index+1..-1]
  sub_string_contain_operator = false
  sub_string_contain_operator = true if operator_array.any? { |w| right_sub_string[w] }
  if sub_string_contain_operator
    d_i = right_sub_string.index('/') if right_sub_string.include('/')
    m_i = right_sub_string.index('*') if right_sub_string.include('*')
    a_i = right_sub_string.index('+') if right_sub_string.include('+')
    s_i = right_sub_string.index('-') if right_sub_string.include('-')
    right_ind = [d_i, m_i, a_i, s_i].min
  else 
    right_ind = right_sub_string.length
  end
  right_number_string = right_sub_string[0...right_ind]
  right_number_string.include?('.') ? right_number_numeric = right_number_string.to_f : right_number_numeric = right_number_string.to_i
# evaluate string
  ans = (left_number_numeric / right_number_numeric).to_s if str[o_index] == '/'
  ans = (left_number_numeric * right_number_numeric).to_s if str[o_index] == '*'
  ans = (left_number_numeric + right_number_numeric).to_s if str[o_index] == '+'
  ans = (left_number_numeric - right_number_numeric).to_s if str[o_index] == '-'
# replace expression with evalutation in string
  if left_number_string + str[o_index] + right_number_string == str
    reduced_str = ans
  else
    reduced_str = str[0...left_ind] + ans + str[o_index+right_ind+1..-1]
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

def eval(str)
# eliminate all whitespace
  str.delete! " "
# declare an array to hold index pairs
  index_pairs = Array.new(2)
# determine if string has parens (while str.include?("("))
  while str.include?(")")
# if yes (find__paren_endices)
    index_pairs = find_paren_endices(str, index_pairs)
# evaluate(substring)
    str = evaluate("30")  #str[index_pairs[0]..index_pairs[1]])
puts "#{str}"
gets
  end
  str
end

expression = "(((5 * 6)-    4)    +   12)/ 2)"
puts eval(expression)