require 'sinatra/base'
require 'json'
require_relative 'assert_system'

# https://docs.travis-ci.com/api

class ImagesDashboard < Sinatra::Base

  get '/' do
    @json = curled_triples

    assert_system "travis login --skip-completion-check --github-token ${GITHUB_TOKEN}"
    token = assert_backtick('travis token --org').strip
    assert_system 'travis logout'

    @repo = @json.keys[4]
    @log = assert_backtick "travis logs --skip-completion-check --org --token #{token} --repo #{cdl}/#{@repo}"

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

  def cdl
    'cyber-dojo-languages'
  end

end
