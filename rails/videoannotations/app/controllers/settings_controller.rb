class SettingsController < ApplicationController
  before_filter :login_required
  layout "user"
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update_attributes(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_to :action => 'index'
      flash[:notice] = "Your settings have been modified succesfully."
    else
      flash[:error]  = "We could not update your settings"
      render :action => 'edit'
    end

  end

end
