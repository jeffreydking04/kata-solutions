a = [[1, 2], [3,4]]

def change(a)
  b = Array.new(2){Array.new(2)}
  b[0][0] = a[0][0]
  b[0][1] = a[0][1]
  b[1][0] = a[1][0]
  b[1][1] = a[1][1]
  puts "a: #{a}"
  puts "b: #{b}"
  b[0][0] = 5
  puts "a: #{a}"
  puts "b: #{b}"
  a[1][1] = 5000
  puts "a: #{a}"
  puts "b: #{b}"  
end

change(a)

