# Holy moly this one needs to be cleaned up!

def fib(n)
  temp = n
  n *= (-1) if temp < 0


  return 0 if n == 0

  count = 0
  num = n
  num -= 1 if num % 2 == 1
  while num > 10 
    count += 1
    num /= 2
    num -= 1 if num % 2 == 1  
  end

  if n < 50 && n > -50
    arr = [0,1]
     (2..n).each do |x|
        arr.push(arr[x-1] + arr[x-2])
      end
      return arr[-1] * (-1) if temp < 0 && (n % 2 == 0)
      return arr[-1]
  end  

  array = [0,1]
  (2..num).each do |x|
      array.push(array[x-1] + array[x-2])
  end 
  
  array2 = [array[-3], array[-2], array[-1]]
  array2.push(array2[1] + array2[2])
  array3 = Array.new(4)
  (1..count).each do |x|
    array3[0] = array2[1] * (2 * array2[2] - array2[1])
    array3[2] = array2[2] * (2 * array2[3] - array2[2])
    array3[1] = array3[2] - array3[0]
    array3[3] = array3[2] + array3[1]
    (0..3).each do |y|
      array2[y] = array3[y]
    end
  end

  remainder = n - (num * 2 ** count - 1) 
  (1..remainder).each do |x|
     array3[0] = array3[3] + array3[2]
     array3[2] = array3[3]
     array3[3] = array3[0]
  end
    array3[1] = array3[3] - array3[2]
  array3[1]

  number = array3[1]


  number *= (-1) if temp < 0 && (n % 2 == 0)

  number
end




puts fib(-6)
puts fib(-91)
puts fib(-22)
puts fib(-30)