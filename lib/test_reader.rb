class TestReader
  class UnsupportedFileError < StandardError; end

  class NoFileError < StandardError; end

  def self.read_from_file(file_path)
    raise NoFileError unless File.exist?(file_path)

    case get_extension(file_path)
    when 'json' then JSONReader.load(file_path)
    when 'xml' then XMLReader.load(file_path)
    else
      raise UnsupportedFileError
    end
  end

  private

  def self.get_extension(file_path)
    # Считываем все символы после последней точки в конце пути к файлу
    pattern = /[^\.]+$/
    # Мы ожидаем единственное вхождение
    # "./some_directory/some_folder/some_file.JSON" => "json"
    file_path.match(pattern).to_s.downcase
  end
end
