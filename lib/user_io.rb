# Класс user input/output
class UserIO
  def output(*some_strings)
    puts
    puts some_strings.join("\n\n")
  end

  def input(some_text = nil)
    puts some_text if !some_text.nil?
    gets.chomp
  end
end
