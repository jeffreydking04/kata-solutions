$walk = 5
$bus = 8
def calculator(distance, bus_drive, bus_walk)
  walk_time = distance.to_f / $walk
  bus_time = bus_drive.to_f / $bus + bus_walk / $walk
  return "Bus" if walk_time > 2
  return "Walk" if walk_time < 0.5
  return "Walk" if walk_time <= bus_time
  return "Bus"
end

puts calculator(5, 6, 1) #"Bus","The bus should win this time!")
puts calculator(4, 5, 1) # Walk","Come on, you can walk this!")
puts calculator(5, 8, 0) # "Walk","If the time is exactly the time, you should walk it!")
puts calculator(5, 4, 3) # "Walk","There's no point taking the bus if it drops you in the middle of nowhere!")
puts calculator(11, 15, 2) # "Bus","Don't be crazy! You'll destroy your lovely shoes!")
puts calculator(0.6, 0.4, 0) # "Walk","Wow. Seriously? How lazy are you?")
puts calculator(10, 0.4, 0) # "Bus","You wouldn't want to walk in this case!")