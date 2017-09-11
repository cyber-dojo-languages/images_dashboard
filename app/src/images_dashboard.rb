require 'sinatra/base'
require 'json'
require_relative 'assert_system'

class ImagesDashboard < Sinatra::Base

  get '/' do
    @json = curled_triples
    erb :home
  end

  # - - - - - - - - - - - - - - -

  get '/languages' do
    @json = curled_triples.select { |repo_name| repo_name =~ /\d/ }
    @json.delete('bash-shunit2')
    @repos = @json.keys
    erb :languages
  end

  # - - - - - - - - - - - - - - -

  get '/test_frameworks' do
    @json = curled_triples.select { |repo_name|
      (repo_name == 'bash-shunit2') ||
        !(repo_name =~ /\d/)
    }
    @json.delete('elm-test-bad-manifest-for-testing')
    @repos = @json.keys
    erb :test_frameworks
  end

  # - - - - - - - - - - - - - - -

  get '/build' do
    repo = params[:repo]
    # https://docs.travis-ci.com/api
    info = `travis show --org --skip-completion-check --repo #{cdl}/#{repo}`
    lines = info.split("\n")
    status = lines[1].split[-1]
    time = lines[5].split[1..-1].join(' ')
    date = lines[6].split[1..-1].join(' ')
    content_type :json
    { :status => status, :time => time, :date => date }.to_json
  end

  # - - - - - - - - - - - - - - -

  private

  include AssertSystem

  def curled_triples
    assert_system "curl --silent --output /tmp/#{triples_filename} #{triples_url}"
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
