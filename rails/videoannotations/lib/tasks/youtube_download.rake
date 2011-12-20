desc "Youtube_Downloader"
task:download_youtube=> :environment do
  @clip = Clip.find(ENV["CLIP_ID"])
  Clip.youtube_download(ENV["YOUTUBE_URL"], @clip.uuid)
  @clip.filename = "video.flv"
  @clip.processed = true
  @clip.save
end