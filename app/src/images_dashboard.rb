require 'sinatra/base'
require 'json'
require_relative 'assert_system'

class ImagesDashboard < Sinatra::Base

  get '/home' do
    @services_repos = service_repos

    @json = curled_triples

    temp = @json.select { |repo_name| repo_name =~ /\d/ }
    temp.delete('bash-shunit2')
    @languages_repos = temp.keys

    temp = @json.select { |repo_name|
      (repo_name == 'bash-shunit2') ||
        !(repo_name =~ /\d/)
    }
    temp.delete('elm-test-bad-manifest-for-testing')
    @test_frameworks_repos = temp.keys

    erb :home
  end

  # - - - - - - - - - - - - - - -

  get '/build' do
    content_type :json
    org = params[:org]
    repo = params[:repo]
    # https://docs.travis-ci.com/api
    info = `travis show --org --skip-completion-check --repo #{org}/#{repo}`
    lines = info.split("\n")
    status = lines[1].split[-1]
    time = lines[5].split[1..-1].join(' ')
    date = lines[6].split[1..-1].join(' ')
    { :status => status, :time => time, :date => date }.to_json
  end

  # - - - - - - - - - - - - - - -

  private

  include AssertSystem

  def service_repos
    %w( collector
        commander
        differ
        grafana
        nginx
        prometheus
        runner
        runner_stateless
        storer
        web
        zipper
    )
  end

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

end
