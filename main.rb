# Задание 12-4 - тест на определение уровня общительности
# На основе http://psylist.net/praktikum/00003.htm

require_relative 'lib/test_reader'
require_relative 'lib/json_reader'
require_relative 'lib/xml_reader'
require_relative 'lib/test'
require_relative 'lib/test_data'
require_relative 'lib/user_io'

test_file_name = File.dirname(__FILE__) + "/data/test1.json"

test_content = TestReader.read_from_file(test_file_name)

user_io = UserIO.new
test = Test.new(test_content)

# Пока тест не завершен
until test.finished?
  # Выводим вопрос и варианты ответа
  user_io.output(test.question, test.answers_string)

  # Считываем ответ, пока не получим подходящий
  user_choice = nil
  until test.answer_accepted?(user_choice)
    user_choice = user_io.input("\nВведите ваш вариант ответа:")
  end
end

# Выводим результат
user_io.output(
  "Набрано баллов: #{test.score}",
  "Ваш результат:",
  test.result_string
)
