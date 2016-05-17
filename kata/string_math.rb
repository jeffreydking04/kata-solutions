def calc(math_str)
puts "original #{math_str}"
        # white space contains no information
  math_str.delete!(" ")
        # create string array for finding operators and parens
  ops_array = %w{* / + - ( )}
  ops_array_no_end_parens = %w{* / + - (}
        # find all '-'s that are really negative signs

        # string cannot begin with binary operator
  math_str[0] = 'n' if math_str[0] == '-'  
        # negative signs will now be preceded by an oper (no ')')
  (1...math_str.length).each do |char|
    math_str[char] = 'n' if ops_array_no_end_parens.include?(math_str[char-1]) && math_str[char] == '-'
  end
  puts "after  initial conversion: #{math_str}"
        # the string is almost ready, but there may be implied parens when a negative sign follows '/' and precedes a '('; for example '2/-(5-4)' will covert to 2/n(5-4) which eventually become 2/-1*(5-4) which evaluates to -2 instead of -1; for all operations other than division, this will not matter as the order of operations will address it, but in the division case, the divisor gets divided by -1 then the result gets multiplied by the evaluation of the parens by left to right, so the implied parens must be added
  while math_str.include?('/n(')      
    (2...math_str.length).each do |index|
      if math_str[index-2] == '/' && math_str[index-1] == 'n' && math_str[index] == '('
        parens_index = 0
        (index...math_str.length).each do |i|
puts "parens index at start of insert: #{parens_index}, math+string[index: #{math_str[index]}, index: #{i}"
          parens_index += 1 if math_str[i] == '('
          parens_index -= 1 if math_str[i] == ')'
puts "after first check: #{parens_index}"
          if parens_index == 0
           parens_index = i + 1
puts "parens_index: #{parens_index}"
            break if parens_index < math_str.length
          end
        end
        parens_index < math_str.length ? math_str.insert(parens_index, ')') : math_str = math_str + ')'
        math_str.insert(index-1, '(')
      end
    end 
  end
puts "after second conversion: #{math_str}"

        # the string now contains only nests {() pairs}, operators, negative signs and numbers,  each number is separted by at least one  of the other items; the following loop is an interpreter that decodes the string placing each item into an array (this is easily the hardest task of this problem), 
  decoded_array = []
  slice_start = 0
  object_found = false

        # special case: when string starts with parens followed by a number
  if math_str[0] == '(' && math_str[1] != '('
    decoded_array.push('(')
    slice_start = 1
  end
  (1...math_str.length).each do |index|
        # 'n' is part of a number, so is '.'  non-numbers can follow non-numbers, however and they must be immediately pushed if an object has just been pushed
    if ops_array.include?(math_str[index]) && object_found
      decoded_array.push(math_str[index])
        # any time we push, the slice_start must be reset
      slice_start = index + 1
      next
    end
        # if the last character in math_str is preceded immediately by an operator or parens (and thus the previous character would have just been pushed and object_found will be true), it must be an end parens or a single digit and must be pushed
    if index == math_str.length - 1 && object_found
      math_str[index] == (')') ? decoded_array.push(math_str[index]) : decoded_array.push(math_str[index].to_i) 
      slice_start = index + 1
    end
        # search is back on, looking for next object and operator, but the very next object could be a parens (cannot be an operator if original string is valid); because this search really finds things in pairs (object first then non-number object), and stops when it has found the second one, if the first one is a non-number object, then the conditionals will not work, so after an object is found, we need to begin the search over by setting object found to false and skipping to the next index 
    if object_found
      object_found = false
      next
    end
        #find the next non-number or end of string because the object that precedes it and itself are of interest

    if ops_array.include?(math_str[index]) || index == math_str.length - 1
puts "index: #{index}, instance of found non-number"
        # if the object that precedes the next found operator is an operator, parens, or negative sign, push the preceding object to the array and move to next opertor
      if ops_array.include?(math_str[index-1]) || (math_str[index-1] == 'n' && index != math_str.length - 1)
        # if a negative sign is followed by an open pares (the only time the next conditional will be true) then it represents multiplying the evaluation of the expression in the parens by -1, so push -1 and then push '*'
        if math_str[index-1] == 'n'
          decoded_array.push(-1)
          decoded_array.push('*')   
         # else the preceding object is an operator or parens and must be pushed to decoded array
        else
          decoded_array.push(math_str[index-1])
        end
        # if the object that precedes the operator is not an operator, parens, or negative sign, it must be a number (the program assumes valid input and those are the only choices)
      else
        # slice out the number into a sub-string
        index == math_str.length - 1 ? number_string = math_str[slice_start..index] : number_string = math_str[slice_start...index]  
puts "number_string slice #{number_string}"
        # if the number starts with n, it is negative
        if number_string[0] == 'n'
          positivity = (-1)
        # delete the negative demarcation from the string
          number_string.delete!('n')
        else
          positivity = 1
        end
        # if number includes '.' it is a float, push accordingly   
        number_string.include?('.') ? decoded_array.push(positivity * number_string.to_f) : decoded_array.push(positivity * number_string.to_i)
        decoded_array.push('*') if math_str[index] == ('(')
      end
        # the original search found the next non-number, it must be pushed
      decoded_array.push(math_str[index])  unless index == math_str.length - 1
      decoded_array.push(math_str[index]) if math_str[index] == ')' && index == math_str.length - 1
        # any time an object pair is found, the next object found might be a number, so we need to mark the beginning of the number so it can be sliced out   
puts "array after each number push: #{decoded_array}"     
      slice_start = index + 1      
        # the search was succesful, so we need to signal the beginning of the loop to start a new search
      object_found = true
    end
  end
puts "decoded array: #{decoded_array}"
        # now eliminate parens by finding nests and evaluating
  while decoded_array.include?(')')
        # find index of close parens of next nest
    end_parens = decoded_array.index(')') 
        # find index of its match open parens
    start_parens = end_parens - decoded_array[0..end_parens].reverse.index('(') 
        # slice out the contents of the nest
    slice = decoded_array.slice!(start_parens + 1, end_parens - start_parens - 1)
        # remove the end parens
    decoded_array.slice!(start_parens + 1)
        # send slice to evaluator and replace the open parens with evaluator's return      
    decoded_array[start_parens] = evaluator(slice)
  end
     

# while ')'s exist, find index of first
# then work back to find the nearest '('
# everything in between should be a number or operator
# store the index of the "("
# slice the values between parens out of array
# delete that specific pair of parens
# send the sliced out array to the solver
   # while mult or div exist
   # the solver searches for first mult or div
   # and sends the numbers on either side to 
   # an appropriate ruby math operator
   # replaces the operator with the answer in the 
   # sliced array, delets the values of the two numbers
   # on either side
   # etc for add and sub
# the solver will return a single number
# it is placed at the index of the original "("
# process is repeated until all parens are gone
# the resulting array is sent to the solver
# the return is the answer
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

exp = '12* 123/(-5 + 2)'
puts "#{calc(exp)}"