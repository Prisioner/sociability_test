require 'rexml/document'

class XMLReader

  class NoFileError < StandardError; end

  def self.load(file_path)
    unless File.exists?(file_path)
      raise NoFileError
    end

    file = File.new(file_path, 'r:UTF-8')

    doc = REXML::Document.new(file)

    file.close

    TestData.new(
      questions: doc.get_elements('test/questions/question').map {|question| question.text.strip},
      answers: parse_xml_section(doc, 'test/answers/answer', ['score']),
      results: parse_xml_section(doc, 'test/results/result', ['score_lower_bound', 'score_upper_bound']),
    )
  end

  private

  def self.parse_xml_section(source, section, keys, with_text = true)
    source.get_elements(section).map do |element|
      result_element = {}
      # на данный момент используются только числовые аттрибуты, поэтому .to_i
      keys.each {|key| result_element[key.to_sym] = element.attributes[key].to_i}
      result_element[:text] = element.text.strip if with_text
      element = result_element
    end
  end
end
