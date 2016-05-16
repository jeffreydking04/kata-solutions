def convert(input, source, target)
  source_base = source.length
  target_base = target.length
  arr = Array.new(input.length)
  (0...input.length).each do |x|
    arr[x]=source.index(input[x])
  end
  arr.reverse!
  sum = 0
  (0...arr.length).each do |x|
    sum += arr[x].to_i * source_base ** x
  end
  return target[0] if sum == 0
  answer = []
  while sum > 0
    answer.push(sum % target_base)
    sum /= target_base
  end
  answer.reverse!
  answer.each_with_index do |x,i|
    answer[i] = target[x]
  end
  answer.each_with_index do |x, i|
    answer[i] = target[answer[i]]
  end
  answer.join("")
end
p "#{convert("0", "0123456789", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")}"