require 'json'

class TestReader
  def self.read_from_file(file_path)
    unless File.exists?(file_path)
      puts "Файл с тестом не найден"
      exit
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
    result = []

    source[section].each do |element|
      result_element = Hash.new
      keys.each { |key| result_element[key.to_sym] = element[key] }
      result << result_element
    end

    result
  end
end
