def calc(math_str)
  math_str.delete!(" ")
  ops_array = %w{* / + - ( )}
  ops_array_no_end_parens = %w{* / + - (}
  math_str[0] = 'n' if math_str[0] == '-'  
  (1...math_str.length).each do |char|
    math_str[char] = 'n' if ops_array_no_end_parens.include?(math_str[char-1]) && math_str[char] == '-'
  end
  while math_str.include?('/n(')      
    (2...math_str.length).each do |index|
      if math_str[index-2] == '/' && math_str[index-1] == 'n' && math_str[index] == '('
        parens_index = 0
        (index...math_str.length).each do |i|
          parens_index += 1 if math_str[i] == '('
          parens_index -= 1 if math_str[i] == ')'
          if parens_index == 0
           parens_index = i + 1
            break if parens_index < math_str.length
          end
        end
        parens_index < math_str.length ? math_str.insert(parens_index, ')') : math_str = math_str + ')'
        math_str.insert(index-1, '(')
      end
    end 
  end
  decoded_array = []
  slice_start = 0
  object_found = false
  if math_str[0] == '(' && math_str[1] != '('
    decoded_array.push('(')
    slice_start = 1
  end
  (1...math_str.length).each do |index|
    if ops_array.include?(math_str[index]) && object_found
      decoded_array.push(math_str[index])
      slice_start = index + 1
      next
    end
    if index == math_str.length - 1 && object_found
      math_str[index] == (')') ? decoded_array.push(math_str[index]) : decoded_array.push(math_str[index].to_i) 
      slice_start = index + 1
    end
    if object_found
      object_found = false
      next
    end
    if ops_array.include?(math_str[index]) || index == math_str.length - 1
      if ops_array.include?(math_str[index-1]) || (math_str[index-1] == 'n' && index != math_str.length - 1)
        if math_str[index-1] == 'n'
          decoded_array.push(-1)
          decoded_array.push('*')   
        else
          decoded_array.push(math_str[index-1])
        end
      else
        index == math_str.length - 1 ? number_string = math_str[slice_start..index] : number_string = math_str[slice_start...index]  
        if number_string[0] == 'n'
          positivity = (-1)
          number_string.delete!('n')
        else
          positivity = 1
        end 
        number_string.include?('.') ? decoded_array.push(positivity * number_string.to_f) : decoded_array.push(positivity * number_string.to_i)
        decoded_array.push('*') if math_str[index] == ('(')
      end
      decoded_array.push(math_str[index])  unless index == math_str.length - 1
      decoded_array.push(math_str[index]) if math_str[index] == ')' && index == math_str.length - 1     
      slice_start = index + 1      
      object_found = true
    end
  end
  while decoded_array.include?(')')
    end_parens = decoded_array.index(')') 
    start_parens = end_parens - decoded_array[0..end_parens].reverse.index('(') 
    slice = decoded_array.slice!(start_parens + 1, end_parens - start_parens - 1)
    decoded_array.slice!(start_parens + 1)   
    decoded_array[start_parens] = evaluator(slice)
  end
  answer = evaluator(decoded_array)
  answer
end

def evaluator(array)
  while array.include?('*') || array.include?('/')
    mult_index = array.index('*') if array.include?('*')
    div_index = array.index('/') if array.include?('/') 
    if mult_index && div_index 
      index = [mult_index, div_index].min
    elsif mult_index
      index = mult_index
    else
      index = div_index
    end
    slice = array[index - 1..index + 1]
    array[index] = binary_op(slice)
    array.slice!(index+1)
    array.slice!(index-1)
    mult_index = nil
    div_index = nil
  end
  while array.include?('+') || array.include?('-')
    add_index = array.index('+') if array.include?('+')
    sub_index = array.index('-') if array.include?('-') 
    if add_index && sub_index 
      index = [add_index, sub_index].min
    elsif add_index
      index = add_index
    else
      index = sub_index
    end
    slice = array[index - 1..index + 1]
    array[index] = binary_op(slice)
    array.slice!(index+1)
    array.slice!(index-1)
    add_index = nil
    sub_index = nil
  end

  array[0]
end

def binary_op(arr)
  case arr[1]
  when '*'
    eval = arr[0] * arr[2]
  when '/'
    eval = arr[0].to_f / arr[2]
  when '+'
    eval = arr[0] + arr[2]
  when '-'
    eval = arr[0] - arr[2]
  end
end

puts calc('123.45*(678.90 / (-2.5+ 11.5)-(80 -19) *33.25) / 20 + 11')