require 'sinatra/base'
require 'json'
require_relative 'assert_system'

class ImagesDashboard < Sinatra::Base

  get '/' do
    @json = curled_triples
    erb :home
  end

  private

  include AssertSystem

  def curled_triples
    assert_system "curl --silent -o /tmp/#{triples_filename} #{triples_url}"
    JSON.parse(IO.read("/tmp/#{triples_filename}"))
  end

  def triples_url
    "https://raw.githubusercontent.com/cyber-dojo-languages/images_info/master/#{triples_filename}"
  end

  def triples_filename
    'images_info.json'
  end

end
