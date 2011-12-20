class AddProcessedToClips < ActiveRecord::Migration
  def self.up
    add_column :clips, :processed, :boolean
  end

  def self.down
  end
end
