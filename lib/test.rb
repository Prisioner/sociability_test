# класс Тест
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
    @answers.map.with_index{ |answer,index| "  #{index + 1} - #{answer[:text]}"}.join("\n")
  end

  # Проверяем валидность ответа. Если ответ подходит - засчитываем его
  def answer_accepted?(answer)
    # Проверяем на nil и строковое значение
    answer = answer.to_i
    # Проверяем валидность ответа
    return false if !answer.between?(1, @answers.size)
    # Засчитываем ответ и переводим тест на следующий вопрос
    @score += @answers[answer-1][:score]
    @question_index += 1
    return true
  end

  # Строка с результатом теста
  def result_string
    return "Тест ещё не завершён!" if !finished?
    @results.find{ |result| @score.between?(result[:score_lower_bound], result[:score_upper_bound]) }[:text]
  end
end
