require 'sinatra/base'
require 'json'
require 'haml'
require 'coffee-script'


class ZVGDemo < Sinatra::Base

  get '/' do
    haml :index
  end

  get '/zvg.css' do
    content_type "text/css"
    File.read(File.expand_path("./app/assets/stylesheets/zvg.css"))
  end

  get '/d3.js' do
    content_type "text/javascript"
    File.read(File.expand_path("./vendor/d3.v3.min.js"))
  end

  get '/zvg/*.js' do
    (coffee File.read(File.expand_path("./app/assets/javascripts/zvg/#{params[:splat][0]}.coffee")))
  end

  run! if app_file == $0
end
