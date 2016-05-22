def validSolution(board)
  (0..8).each do |x|
    return false if board[x].include?(0)
    return false if board[x].uniq.size != 9
    array = []
    (0..8).each do |y|
      array.push(board[y][x])
    end
    return false if array.uniq.size != 9
  end
  (0..7).step(3).each do |w|
    (0..7).step(3).each do |x|
      array = []
      (0..2).each do |y|
        (0..2).each do |z|
          array.push(board[w+y][x+z])
        end
      end
      return false if array.uniq.size != 9
    end
  end
  true
end

a = [[5, 3, 4, 6, 7, 8, 9, 1, 2], 
    [6, 7, 2, 1, 9, 5, 3, 4, 8],
    [1, 9, 8, 3, 4, 2, 5, 6, 7],
    [8, 5, 9, 7, 6, 1, 4, 2, 3],
    [4, 2, 6, 8, 5, 3, 7, 9, 1],
    [7, 1, 3, 9, 2, 4, 8, 5, 6],
    [9, 6, 1, 5, 3, 7, 2, 8, 4],
    [2, 8, 7, 4, 1, 9, 6, 3, 5],
    [3, 4, 5, 2, 8, 6, 1, 7, 9]]

puts validSolution(a)