require 'sinatra/base'
require 'json'

class ImagesDashboard < Sinatra::Base

  get '/' do
    erb :home
  end

end
