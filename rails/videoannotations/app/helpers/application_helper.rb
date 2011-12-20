# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def self.serverUrl
    if RAILS_ENV == "development"
      return "http://localhost:3000"
    else
      return "http://lienzo.yoteinvoco.com"
    end
  end
end
