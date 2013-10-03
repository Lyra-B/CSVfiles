require 'pry'

class Reader
  def read(file_path)
    File.open(file_path) do |f|
      f.each_line do |l|
        tokens =  l.split(",")
        binding.pry
      end
    end
  end
end

Reader.new.read "data.csv"