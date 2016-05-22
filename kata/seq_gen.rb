def sequence_gen(*input)
  x = input.size
  seq = Enumerator.new do |y|
    loop do
      y << input[0]
      sum = 0
      (0...x).each do |z|
        sum += input[z]
      end
      input.push(sum)
      input.delete_at(0)
    end
  end
  seq
end

fib =  sequence_gen(0,1)
puts fib.next