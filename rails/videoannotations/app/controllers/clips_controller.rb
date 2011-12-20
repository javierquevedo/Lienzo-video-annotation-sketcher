require 'rubygems'
require 'uuidtools'
class ClipsController < ApplicationController

  before_filter :login_required, :except => [:new, :create, :show]
  def index
    @clips = current_user.clips
  end

  def show
    @clip = Clip.find(params[:id])
    if !@clip.processed
      flash[:notice] ="Clip is being processed, please try again in a few minutes"
      if logged_in?
        redirect_to clips_path
      else
        redirect_to home_path
      end
    end
    @serverUrl =  ApplicationHelper.serverUrl
  end

  def new
    @clip = Clip.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @datafile }
    end
  end

  def create
    @clip = Clip.new(params[:clip])
    #afilename = nil
    # Cheap validation to see if the video extension is valid
   # if params[:attachment].type == 'Tempfile'
   #   afilename = params[:attachment].original_filename
   # end
   # puts params[:attachment].class
   # if afilename && ![".flv",".mp4"].include?(File.extname(afilename)) && !(@clip.original_source_url.length > 0)
   begin
     if ![".flv",".mp4",".mpg"].include?(File.extname(params[:attachment].original_filename))
     puts "not the correct file extension"
         respond_to do |format|
          flash[:notice] = "Video upload was invalid."
          format.html { render :action => "new" }
          format.xml  { render :xml => current_user.errors, :status => :unprocessable_entity }
          end
      return
      end
   rescue
    puts "not an attachment"
    end

    if RAILS_ENV == "development"
      @clip.uuid = UUIDTools::UUID.timestamp_create().to_s
    else
      @clip.uuid = rand(900000000).to_s
    end

    @clip.filename = Clip.save(params[:attachment], @clip.uuid)
      
    @clip.processed = true
    succeded = @clip.save
    unless @clip.errors.empty?
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => current_user.errors, :status => :unprocessable_entity }
      end
      return
    end


    if !@clip.filename
      if @clip.original_source_url &&  @clip.original_source_url.length > 0
        @clip.processed = false
        @clip.save
        system "rake --trace download_youtube CLIP_ID=#{@clip.id} YOUTUBE_URL=#{@clip.original_source_url} &"
      end
    end
    if logged_in?
      current_user.clips.push(@clip)
      current_user.save
    end
    respond_to do |format|
      if succeded
        flash[:notice] = 'Clip was successfully created.'
        if logged_in?
          format.html { redirect_to(clips_url) }
          format.xml  { render :xml => current_user, :status => :created, :location => current_user }
        else
          if @clip.processed == true
            format.html { redirect_to(@clip) }
            format.xml  { render :xml => @clip, :status => :created }
          else
            flash[:notice] = "The video is being processed. Please wait a few minutes."
            format.html { redirect_to(home_path) }
            format.xml  { render :xml => @clip, :status => :created }
          end
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => current_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @clip = Clip.find(params[:id])
    @clip.destroy
    respond_to  do|format|
      flash[:notice] = 'Clip was succesfully destroyed'
      format.html { redirect_to(clips_url) }
      format.xml  { head :ok }
    end
  end

end