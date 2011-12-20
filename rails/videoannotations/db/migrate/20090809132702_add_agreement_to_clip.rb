class AddAgreementToClip < ActiveRecord::Migration
  def self.up
    add_column :clips, :agreed, :boolean
  end

  def self.down
  end
end
