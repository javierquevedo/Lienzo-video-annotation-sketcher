class HomeController < ApplicationController
  def index
    @clips = Clip.find(:all, :limit => 25, :order => "created_at DESC")
  end
end
