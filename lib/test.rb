class Test
  attr_reader :score

  def initialize(options = {})
    # Массив вопросов
    @questions = options[:questions]
    # Массив ответов
    @answers = options[:answers]
    # Массив результатов теста
    @results = options[:results]
    # Здесь подсчитываем баллы
    @score = 0
    # Здесь храним номер текущего вопроса
    @question_index = 0
  end

  def finished?
    @question_index >= @questions.size
  end

  # Текущий вопрос
  def question
    "Вопрос №#{@question_index + 1}:\n#{@questions[@question_index]}"
  end

  # Варианты ответа
  def answers_string
    # Все варианты ответа форматируются в вид "1 - Да" и выводятся каждый на своей строке
    @answers.map.with_index { |answer, index| "  #{index + 1} - #{answer.text}"}.join("\n")
  end

  # Проверяем валидность ответа. Если ответ подходит - засчитываем его
  def answer_accepted?(answer)
    # Проверяем на nil и строковое значение
    answer = answer.to_i
    
    # Проверяем валидность ответа
    return false unless answer.between?(1, @answers.size)
    
    # Засчитываем ответ и переводим тест на следующий вопрос
    @score += @answers[answer-1].score
    @question_index += 1
    # Возвращается не false и не nil, что воспринимается как "правдоподобный" результат
  end

  # Строка с результатом теста
  def result_string
    return "Тест ещё не завершён!" unless finished?
    
    @results.find { |result| result.hit?(@score) }.text
  end
end
