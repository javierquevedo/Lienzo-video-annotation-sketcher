class CreateClips < ActiveRecord::Migration
  def self.up
    create_table :clips do |t|
      t.integer :user_id
      t.column :name, :string
      t.column :description, :string
      t.column :filename, :string
      t.string :uuid, :limit => 36, :primary => true
      t.timestamps
    end

  end

  def self.down
    drop_table :clips
  end
end
