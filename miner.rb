# branch explore is called if the miner has a choice of directions
# it does not assume that there is only one solution
# if the branch leads to the exit, it returns a complete 
# answer (i.e. from the original location), which is 
# compared later against other possible solutions for
# length
# branch explore is passed the direction it is exploring
# it adjusts the position of the miner dependent on direction
# then makes a copy of the hash of the miner's position
# for passing recursively back to solve
# the solve function is recursivley called and the return
# set equal to the copy of the answer array
# the solve function returns an empty array of the size of
# total number of elements in the map if it hits a dead end
# if the branch explore finds the exit, it returns the path
# from the original position of the miner (an actual true path,
# but maybe not the shortest one)
# in this case, the first position of the branch on the copy
# of the map is set equal to 'branch' to signal that this 
# branch is a valid branch to exit
# the position of the miner is reset to the position before
# the branch and the path is the return to main

def  branch_explore(copy_of_map_arr, direction, exit_hash, copy_of_answer_array, x, y, x_max, y_max)
  x += 1 if direction == 'right'
  x -= 1 if direction == 'left'
  y -= 1 if direction == 'up'
  y += 1 if direction == 'down'
  temp_miner = {'x' => x, 'y' => y}
  copy_of_answer_array = solve(copy_of_map_arr, temp_miner, exit_hash, copy_of_answer_array)
  if copy_of_answer_array.size == ((x_max + 1) * (y_max + 1))  
    copy_of_map_arr[x][y] = false 
  else
    copy_of_map_arr[x][y]  == "branch"
  end
  x -= 1 if direction == 'right'
  x += 1 if direction == 'left'
  y += 1 if direction == 'up'
  y -= 1 if direction == 'down'
  copy_of_answer_array
end 

# I had problems with array1 = array2
# This appears to link the two arrays, which I did not want
# values changed in one were reflected in the other
# copy_array assigns individual elements of one
# array to another and avoids the linking problem
# single dimensional arrays only

def copy_array(arr)
  a = Array.new(arr.length)
  a.each_with_index do |v,i|
    a[i] = arr[i]
  end
  a
end

# solve returns the path in array form
# this code can be streamlined in so many ways!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

def solve(minemap, miner, exit, answer = [])
# this block sets variables for dimension max indexes
# declares variables for the current miner position
# declares variables for the exit position
# I did this for easier manipulation of the values
# than referring to and changing a hash constantly
# it also sets up an array possible values the map
# can take on, with the direction a miner should travel
# replacing true, which signals to the miner that he
# should not return to that position (probably not necessary
# because false would work just as well unless two branches
# are both valid, but right, left, up, down could probably
# be eliminated

  x_max = minemap.size - 1
  y_max = minemap[0].size - 1
  x = miner['x']
  y = miner['y']
  ex = exit['x']
  ey = exit['y']
  walls = %w(right left up down branch)
  walls.push(false)

# copying the map so it can be manipulated (again, probably
# not necessary and, even if it is, my copy_array should be
# expanded to multi dimensional arrays)

  copy = Array.new(x_max+1){Array.new(y_max+1)}
    (0..x_max).each do |x|
      (0..y_max).each do |y|
       copy[x][y] = minemap[x][y]
      end
    end

# loops while not at exit

  while x != ex || y != ey

# sets a boolean array to 4 trues, then checks
# each possible move to false if unavailable

    rlud = [true, true, true, true]
    rlud[0] = false if x == x_max || walls.include?(copy[x+1][y])
    rlud[1] = false if x == 0 || walls.include?(copy[x-1][y])
    rlud[2] = false if y == 0 || walls.include?(copy[x][y-1])
    rlud[3] = false if y == y_max || walls.include?(copy[x][y+1])

# if there is nowhere to turn, the answer array is set to an array 
# of size equal to thenumber of elements in the map, because this 
# number is more than the possible number of steps the miner could
# take in an actual solution, then returns this array as answer
# this signals the previous call of solve that the branch was a 
# dead end (this will not happen on the first iteration by if
# the initial conditions are valid)

    answer = Array.new((x_max + 1)  * (y_max + 1)) if rlud.count(true) == 0 
    return answer if rlud.count(true) == 0

# if there is only one path (only one true in the boolean array)
# then the position is updated, the step is pushed to the answer
# array and the copy of the original position is set to a string
# indicating the miner must travel

    if rlud.count(true) == 1       
      if rlud[0] == true
        copy[x][y] = "right"        
        answer.push('right')
        x += 1
      elsif rlud[1] == true
        copy[x][y] = "left"        
        answer.push('left')
        x -= 1
      elsif rlud[2] == true
        copy[x][y] = "up"        
        answer.push('up')
        y -= 1
     else
        copy[x][y] = "down"
        answer.push('down')
        y += 1      
      end   

# if there is more than one possible move, this section
# calls the branch explore with the direction to explore
# as one parameter and a copy of the answer to be appended 
# to in case a valid path is found,  if a dead end is reached
# branch_explore will mark the initial branch position as false

    else
      copy[x][y] = false
      if rlud[0] == true
        r = copy_array(answer)
        r = branch_explore(copy, 'right', exit, r, x, y, x_max, y_max)
      end       
       if rlud[1] == true
        l = copy_array(answer)
        l = branch_explore(copy, 'left', exit, l, x, y, x_max, y_max)
      end
      if rlud[2] == true
        u = copy_array(answer)        
        u = branch_explore(copy, 'up', exit, u, x, y, x_max, y_max)
      end
      if rlud[3] == true
        d = copy_array(answer)
        d = branch_explore(copy, 'down', exit, d, x, y, x_max, y_max)
      end

# this section pushes the answer arrays that are valid paths to
# a branch array 

      branch_array = []     
      branch_array.push(r.size) if x != x_max && copy[x+1][y].to_s == "branch"
      branch_array.push(l.size) if x != 0 && copy[x-1][y].to_s == "branch"
      branch_array.push(u.size) if y != 0 && copy[x][y-1].to_s == "branch"
      branch_array.push(d.size) if y != y_max && copy[x][y+1].to_s == "branch"

# this determines which of the potential valid paths is shorts and 
# set the answer to that array
      
      min = branch_array.min
      answer = copy_array(r) if r != nil && r.size == min
      answer = copy_array(l) if l != nil && l.size == min
      answer = copy_array(u) if u != nil && u.size == min
      answer = copy_array(d) if d != nil && d.size == min
    end
  end

# return the answer

  answer
end

minemap = [[true, true, true], [false, true, false], [false, true, true]]

miner = {'x' => 0, 'y' => 0}
exit = {'x' => 2, 'y' => 2}

p solve(minemap, miner, exit)

