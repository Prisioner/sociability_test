class TestData
  attr_reader :questions, :answers, :results

  class FormatError < StandardError;
  end

  def initialize(opts)
    @questions = validate_questions(opts[:questions])

    @answers = opts[:answers]
    @results = opts[:results]
  end

  def [] (type)
    case type
    when :questions then @questions
    when :answers then @answers
    when :results then @results
    end
  end

  private

  def validate_questions(questions)
    # Проверяем, что questions - не nil и не пуст
    raise FormatError if questions.nil? || questions.empty?
    # Проверяем наличие пустых вопросов
    raise FormatError if questions.any? {|question| question.nil? || question.strip == ""}

    questions
  end
end
