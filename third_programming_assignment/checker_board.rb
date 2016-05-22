def checkered_board(dimension)
  return false if !(dimension.is_a?Integer)
  return false if dimension < 2
  string = ""
    (1..dimension).each do |x|
      (1..dimension).each do |y|
        if y != dimension
          ((dimension % 2 == 0) && (x % 2 == y % 2)) || ((dimension % 2 == 1) && (x % 2 != y % 2)) ? string = string + "\u25A1 " : string = string + "\u25A0 "
        else
          ((dimension % 2 == 0) && (x % 2 == y % 2)) || ((dimension % 2 == 1) && (x % 2 != y % 2)) ? string = string + "\u25A1" : string = string + "\u25A0"         
        end
      end
      string = string + "\n" unless x == dimension
    end
  string 
end

p checkered_board(2)