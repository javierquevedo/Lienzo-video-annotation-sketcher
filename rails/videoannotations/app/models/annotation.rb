class Annotation < ActiveRecord::Base
  belongs_to :clip
  Basedir = "public/data/"
  def self.save(upload, uuid)
      self.createdir(uuid)
      self.writefile(upload, uuid)
      return upload.original_filename
      # create the file path

      #File.open(path, "wb") { |f| f.write(upload.read)}
      rescue Exception => exception
        case exception
          when Errno::EEXIST
            writefile(upload, uuid)
            return upload.original_filename
         end
    end
  private
    def self.createdir(uuid)
      Dir.chdir("#{RAILS_ROOT}")
      directory = Basedir + uuid
      Dir.mkdir(directory)
    end

    def self.writefile(upload, uuid)
      Dir.chdir("#{RAILS_ROOT}")
      directory = Basedir + uuid

      path = File.join(directory, upload.original_filename)
      content = upload.read
      # write the file
      File.open(path, "w") do |f|
        f.write(content)
        f.close
      end
    end
end
