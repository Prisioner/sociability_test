class TestAnswer
  attr_reader :text, :score

  class FormatError < StandardError; end

  def initialize(opts)
    @text = opts[:text]
    @score = opts[:score]

    # Проверяем, что @text не nil и не пуст
    raise FormatError if @text.nil? || @text.strip == ""
    # Проверяем, что score ни nil и содержит число
    raise FormatError if @score.nil?
    raise FormatError unless @score.is_a?(Numeric)
  end

  def [] (type)
    case type
    when :text then @text
    when :score then @score
    end
  end
end
