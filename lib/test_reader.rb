require 'json'

class TestReader
  def self.read_from_file(file_path)
    unless File.exists?(file_path)
      raise "Файл с тестом не найден"
    end

    file = File.read(file_path, encoding: "utf-8")
    content = JSON.parse(file)

    {
      questions: content['questions'],
      answers: parse_json(content, 'answers', ['text', 'score']),
      results: parse_json(content, 'results', ['text', 'score_lower_bound', 'score_upper_bound'])
    }
  end

  private

  def self.parse_json(source, section, keys)
    source[section].map do |element|
      result_element = {}
      keys.each { |key| result_element[key.to_sym] = element[key] }
      element = result_element
    end
  end
end
