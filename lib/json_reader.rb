require 'json'

class JSONReader

  class NoFileError < StandardError; end

  def self.load(file_path)
    unless File.exists?(file_path)
      raise NoFileError
    end

    file = File.read(file_path, encoding: 'UTF-8')
    content = JSON.parse(file)

    TestData.new(
      questions: content['questions'],
      answers: parse_json_section(content, 'answers', ['text', 'score'], TestAnswer),
      results: parse_json_section(content, 'results', ['text', 'score_lower_bound', 'score_upper_bound'], TestResult)
    )
  end

  private

  def self.parse_json_section(source, section, keys, entity)
    source[section].map do |element|
      result_element = {}
      keys.each { |key| result_element[key.to_sym] = element[key] }
      element = entity.new(result_element)
    end
  end
end
