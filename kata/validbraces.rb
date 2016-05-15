def validBraces(braces)
  string_array = braces.split("")
  array = Array.new(string_array.size, 0)
  return false if array.size % 2 == 1
  string_array.each_with_index do |x, i|
    case x
    when "{"
      array[i] = -3
    when "["
      array[i] = -2
    when "("
      array[i] = -1
    when ")"
      array[i] = 1
    when "]"
      array[i] = 2
    when "}"
      array[i] = 3
    end
  end
 
  while (array.size > 0)
    (0...array.size).each do |x|
      return false if array[x] > 0
      return false if x == array.size - 1
      next if array[x+1] < 0
      return false if  array[x] + array[x+1] != 0
      array.delete_at(x)
      array.delete_at(x)
      break
    end
  end

  true
end

a = "{{({[}])}}"
b = "{([])}"

puts validBraces(a)
puts validBraces(b)
