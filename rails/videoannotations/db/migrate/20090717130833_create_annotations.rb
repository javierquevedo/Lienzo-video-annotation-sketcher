class CreateAnnotations < ActiveRecord::Migration
  def self.up
    create_table :annotations do |t|
      t.column :name, :string
      t.column :author, :string
      t.column :content,  :string
      t.column :contenttype, :string
      t.float  :starttime
      t.float :duration
      t.float :alpha
      t.float :fadeduration
      t.integer :clip_id
      t.timestamps
    end
  end

  def self.down
    drop_table :annotations
  end
end
