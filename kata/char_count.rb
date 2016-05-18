def validate_word(word)
  word.downcase!
  array = word.split("")
  array_uniq = array.uniq
  array_count = []
  array_uniq.each do |x|
    array_count.push(array.count(x))
  end
  array_count.uniq.size == 1
end