def most_frequent_item_count(collection)
  return 0 if collection == []
  array = collection.uniq
  count_array = []
  array.each {|x| count_array.push(collection.count(x))}
  count_array.max
end