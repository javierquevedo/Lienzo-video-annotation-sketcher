class AddYoutubeUrlToClip < ActiveRecord::Migration
  def self.up
    add_column :clips, :original_source_url, :string
  end

  def self.down
  end
end
