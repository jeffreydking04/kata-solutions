def copy_array(arr)
  a = Array.new(arr.length)
  a.each_with_index do |v,i|
    a[i] = arr[i]
  end
  a
end

def solve(minemap, miner, exit, answer = [])
  x_max = minemap.size - 1
  y_max = minemap[0].size - 1
  x = miner['x']
  y = miner['y']
  ex = exit['x']
  ey = exit['y']
  walls = %w(up down right left branch)
  walls.push (false)

copy = Array.new(x_max+1){Array.new(y_max+1)}
  (0..x_max).each do |x|
    (0..y_max).each do |y|
      copy[x][y] = minemap[x][y]
    end
  end

  while x != ex || y != ey

    rlud = [true, true, true, true]
    rlud[0] = false if x == x_max || walls.include?(copy[x+1][y])
    rlud[1] = false if x == 0 || walls.include?(copy[x-1][y])
    rlud[2] = false if y == 0 || walls.include?(copy[x][y-1])
    rlud[3] = false if y == y_max || walls.include?(copy[x][y+1])

    answer = Array.new((x_max + 1)  * (y_max + 1)) if rlud.count(true) == 0 
    return answer if rlud.count(true) == 0
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
    else
      if rlud[0] == true
        answer.push('right')
        copy[x][y] = ("right")
        x += 1
        temp_miner = {'x' => x, 'y' => y}
        r = copy_array(answer)
        r = solve(copy, temp_miner, exit, r)
        if r.size == ((x_max + 1) * (y_max + 1))  
          copy[x][y] = false 
        else
          copy [x][y]  == "branch"
        end
        answer.pop        
        x -= 1        
      end  
      if rlud[1] == true
        answer.push('left')
        copy[x][y] = "left"
        x -= 1
        temp_miner = {'x' => x, 'y' => y}
        l = copy_array(answer)
        l = solve(copy, temp_miner, exit, l)
        if l.size == ((x_max + 1) * (y_max + 1))  
          copy[x][y] = false
        else
          copy [x][y]  == "branch"
        end
        answer.pop
        x += 1
      end
      if rlud[2] == true
        answer.push('up')
        copy[x][y] = "up"
        y -= 1
        temp_miner = {'x' => x, 'y' => y}
        u = copy_array(answer)
        u = solve(copy, temp_miner, exit, u)
        if u.size == ((x_max + 1) * (y_max + 1))  
          copy[x][y] = false 
        else
          copy [x][y]  == "branch"
        end
        answer.pop
        y += 1
      end
      if rlud[3] == true
        answer.push('down')
        copy[x][y] = "down"
        y += 1
        temp_miner = {'x' => x, 'y' => y}
        d = copy_array(answer)
        d = solve(copy, temp_miner, exit, d)
        if d.size == ((x_max + 1) * (y_max + 1))  
          copy[x][y] = false 
        else
          copy [x][y]  == "branch"
        end
        answer.pop        
        y -= 1
      end

      branch_array = []     
      branch_array.push(r.size) if x != x_max && copy[x+1][y].to_s == "branch"
      branch_array.push(l.size) if x != 0 && copy[x-1][y].to_s == "branch"
      branch_array.push(u.size) if y != 0 && copy[x][y-1].to_s == "branch"
      branch_array.push(d.size) if y != y_max && copy[x][y+1].to_s == "branch"
      min = branch_array.min
      answer = copy_array(r) if r != nil && r.size == min
      answer = copy_array(l) if l != nil && l.size == min
      answer = copy_array(u) if u != nil && u.size == min
      answer = copy_array(d) if d != nil && d.size == min
    end
  end

  answer
end

minemap = [[true, true, true], [false, true, false], [false, true, true]]

miner = {'x' => 0, 'y' => 0}
exit = {'x' => 2, 'y' => 2}

p solve(minemap, miner, exit)

