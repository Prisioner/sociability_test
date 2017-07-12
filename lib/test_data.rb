class TestData
  attr_reader :questions, :answers, :results

  class FormatError < StandardError;
  end

  def initialize(opts)
    @questions = parse_questions(opts[:questions])

    @answers = parse_answers(opts[:answers])

    @results = parse_results(opts[:results])
  end

  def [] (type)
    case type
      when :questions then
        @questions
      when :answers then
        @answers
      when :results then
        @results
    end
  end

  private

  def parse_questions(questions)
    # Проверяем, что questions - не nil и не пуст
    raise FormatError if questions.nil? || questions.empty?
    # Проверяем наличие пустых вопросов
    raise FormatError if questions.any? {|question| question.nil? || question.strip == ""}

    questions
  end

  def parse_answers(answers)
    # Проверяем, что answers - не nil и не пусть
    raise FormatError if answers.nil? || answers.empty?
    # Проверяем наличие пустых вариантов ответа или некорректных данных
    raise FormatError if answers.any? do |answer|
      answer.nil? ||
        answer[:score].nil? ||
        !answer[:score].is_a?(Numeric) ||
        answer[:text].nil? ||
        answer[:text].strip == ""
    end

    answers
  end

  def parse_results(results)
    # Проверяем, что results - не nil и не пуст
    raise FormatError if results.nil? || results.empty?
    # Проверяем наличие пустых результатов или некорректных данных
    raise FormatError if results.any? do |result|
      result.nil? ||
        result[:text].nil? ||
        result[:text].strip == "" ||
        result[:score_lower_bound].nil? ||
        !result[:score_lower_bound].is_a?(Numeric) ||
        result[:score_upper_bound].nil? ||
        !result[:score_upper_bound].is_a?(Numeric)
    end

    results
  end
end
