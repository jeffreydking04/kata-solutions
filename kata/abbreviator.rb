class Abbreviator

  def self.abbreviate(string)
    while string[/\b[a-z]{5,}\b/i] != nil
      slice = string[/\b[a-z]{5,}\b/i]
      len = slice.length - 2
      abbr = slice[0] + len.to_s + slice[-1]
      string.sub!(/\b[a-z]{5,}\b/i, "#{abbr}" )
    end
    string
  end
end


puts Abbreviator.abbreviate("double-barrel")