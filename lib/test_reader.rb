require 'json'
require 'rexml/document'

class TestReader
  NO_FILE_ERROR = "Файл с тестом не найден"
  UNSUPPORTED_FILE_ERROR = "Формат файла не распознан или не поддерживается"

  def self.read_from_file(file_path)
    case get_extension(file_path)
    when 'json' then read_from_json_file(file_path)
    when 'xml' then read_from_xml_file(file_path)
    else
      raise UNSUPPORTED_FILE_ERROR
    end
  end

  def self.read_from_xml_file(file_path)
    unless File.exists?(file_path)
      raise NO_FILE_ERROR
    end

    file = File.new(file_path, 'r:UTF-8')

    doc = REXML::Document.new(file)

    file.close

    {
      questions: doc.get_elements('test/questions/question').map { |question| question.text.strip },
      answers: parse_xml_section(doc, 'test/answers/answer', ['score']),
      results: parse_xml_section(doc, 'test/results/result', ['score_lower_bound', 'score_upper_bound']),
    }
  end

  def self.read_from_json_file(file_path)
    unless File.exists?(file_path)
      raise NO_FILE_ERROR
    end

    file = File.read(file_path, encoding: 'UTF-8')
    content = JSON.parse(file)

    {
      questions: content['questions'],
      answers: parse_json_section(content, 'answers', ['text', 'score']),
      results: parse_json_section(content, 'results', ['text', 'score_lower_bound', 'score_upper_bound'])
    }
  end

  private

  def self.get_extension(file_path)
    # Считываем все символы после последней точки в конце пути к файлу
    pattern = /[^\.]+$/
    # Мы ожидаем единственное вхождение
    # "./some_directory/some_folder/some_file.JSON" => "json"
    file_path.match(pattern).to_s.downcase
  end

  def self.parse_json_section(source, section, keys)
    source[section].map do |element|
      result_element = {}
      keys.each { |key| result_element[key.to_sym] = element[key] }
      element = result_element
    end
  end

  def self.parse_xml_section(source, section, keys, with_text = true)
    source.get_elements(section).map do |element|
      result_element = {}
      # на данный момент используются только числовые аттрибуты, поэтому .to_i
      keys.each { |key| result_element[key.to_sym] = element.attributes[key].to_i }
      result_element[:text] = element.text.strip if with_text
      element = result_element
    end
  end
end
