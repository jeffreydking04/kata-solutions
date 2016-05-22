def longest_palindrome(string)
  return 0 if string.length == 0
  answer = 1
  (1...string.length).each do |x|
    next if string[x] != string[x-1]
    p_start = x-2
    p_end   = x+1
    while p_start >= 0 && p_end < string.length
      break if string[p_start] != string[p_end]
      p_start -= 1
      p_end += 1
    end
    answer = p_end - p_start - 1
  end
  (2...string.length).each do |x|
    next if string[x] != string[x-2]
    p_start = x-3
    p_end   = x+1
    while p_start >= 0 && p_end < string.length
      break if string[p_start] != string[p_end]
      p_start -= 1
      p_end += 1
    end
    answer = p_end - p_start - 1 if (p_end - p_start - 1) > answer
  end
  answer
end

puts longest_palindrome("cbbczklkzc")