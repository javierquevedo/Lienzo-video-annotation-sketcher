class Clip < ActiveRecord::Base
  has_many :annotations
  belongs_to :user

 Basedir = "public/data/"

  attr_accessor :password
  validates_presence_of     :name
  validates_presence_of     :description
  validates_presence_of     :original_source_url, :if => :not_file_upload?, :message => "must exist or a file a new video must be uploaded"
  #validates_format_of(:original_source_url, :with => /^((http?):\/\/www\.((?:[-a-z0-9]+\.)+[a-z]{2,}))/,:if => :not_file_upload?, :message=>"is not a youtube url")
  #validates_presence_of     :filename, :if => :not_other_source?
  validates_inclusion_of :agreed, :in => [true], :message => "The terms of use must be agreed in order to create the clip"
  validates_format_of :original_source_url, :with => /^http:\/\/www.youtube\.com\/watch\?v=[\w-]{11}/ ,:if => :not_file_upload?, :message=>"is not a youtube url"

  validates_length_of       :name,    :within => 3..40
  validates_length_of       :description,    :within => 3..1024

  attr_accessible :name, :description, :original_source_url, :processed, :filename, :agreed


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

  def self.youtube_download(url, uuid)
    Dir.chdir(File.join("#{RAILS_ROOT}", "private"))
    if RAILS_ENV == "development"
      pythoncmd = "python"
    else
      pythoncmd = "python2.4"
    end
    system "#{pythoncmd} youtube-dl.py #{url} -o ../public/data/#{uuid}/video.flv"
  end
  
 protected
    def not_file_upload?
      !filename || filename.length==0
    end

    def not_other_source?
      original_source_url #|| original_source_url.length > 0
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
      File.open(path, "wb") { |f| f.write(upload.read) }

      #content = upload.read
      # write the file
      #File.open(path, "w") do |f|
      #  f.write(content)
      #  f.close
      #end
    end
end
