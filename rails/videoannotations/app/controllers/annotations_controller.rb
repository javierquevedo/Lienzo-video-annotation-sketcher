class AnnotationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :login_required, :only=> [:destroy]
  def index
    @clip = Clip.find(params[:clip_id])
    @annotations = @clip.annotations
    respond_to do |format|
      format.html
      format.xml {render :xml => @annotations.to_xml(:except => :content)}
    end
  end

  def edit
    @clip = Clip.find(params[:clip_id])
    @annotation = Annotation.find(params[:id])
  end

  def update
    @annotation= Annotation.find(params[:id])
    @annotation.update_attributes(params[:annotation])
    @annotation.save
    flash[:notice] = 'Annotation was modified succesfully'
    redirect_to clip_annotations_path
  end

  def show
    @clip = Clip.find(params[:clip_id])
    @annotation = Annotation.find(params[:id])
    respond_to do |format|
      format.html
      format.xml {render :xml => @annotation}
    end
  end

  def new
    @clip = Clip.find(params[:clip_id])
    @annotation = Annotation.new
  end

  def create
    @clip = Clip.find(params[:clip_id])
    @annotation = Annotation.new(params[:annotation])
    #@annotation.filename = Annotation.save(params[:attachment], @clip.uuid)
    @clip.annotations.push(@annotation)
    respond_to do |format|
      if @clip.save
        flash[:notice] = 'Clip was successfully created.'
        format.html { redirect_to(clip_annotations_url(@clip)) }
        format.xml  { render :xml => @annotation.to_xml(:except => :content), :status => :created}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @annotation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @annotation = Annotation.find(params[:id])
    @annotation.destroy
    flash[:notice] = "Annotation was destroyed succesfully"
    redirect_to clip_annotations_path(params[:clip_id])

  end
end
