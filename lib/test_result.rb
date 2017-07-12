class TestResult
  attr_reader :text, :score_lower_bound, :score_upper_bound

  class FormatError < StandardError; end

  def initialize(opts)
    @text = opts[:text]
    @score_lower_bound = opts[:score_lower_bound]
    @score_upper_bound = opts[:score_upper_bound]

    # Проверяем поле text на nil или пустую строку
    raise FormatError if @text.nil? || @text.strip == ""
    # Проверяем балльные границы результата на nil
    raise FormatError if @score_lower_bound.nil? || @score_upper_bound.nil?
    # Проверяем, что балльные границы результата - числа
    raise FormatError unless @score_lower_bound.is_a?(Numeric) || @score_upper_bound.is_a?(Numeric)
  end

  def [] (type)
    case type
    when :text then @text
    when :score_lower_bound then @score_lower_bound
    when :score_upper_bound then @score_upper_bound
    end
  end

  # Проверяем, что результат подходит под набранное количество очков
  def hit?(score)
    score.between?(@score_lower_bound, @score_upper_bound)
  end
end
