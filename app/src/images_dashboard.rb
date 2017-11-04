require 'sinatra/base'
require 'json'
require 'time_difference'
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

    @tools_repos = [
      'image_builder'
    ]

    erb :home
  end

  # - - - - - - - - - - - - - - -

  get '/build' do
    content_type :json
    org = params[:org]
    repo = params[:repo]
    # https://docs.travis-ci.com/api
    info = `travis show --org --skip-completion-check --repo #{org}/#{repo}`
    begin
      lines = info.split("\n")
      { :status => Xstatus(lines),
        :ago => ago(lines),
        :took => took(lines)
      }.to_json
    rescue Exception => e
      { :status => lines.join('<br/>') + '<br/>' + e.message,
        :ago => '?',
        :took => '?'
      }.to_json
    end
  end

  # - - - - - - - - - - - - - - -

  private

  def Xstatus(lines) # don't call this status!
    # 'State: passed'
    found = lines.find { |line| line.strip.start_with? 'State:' }
    found.split(':')[1].strip # 'passed'
  end

  def ago(lines)
    # Finished: 2017-11-04 08:55:32
    found = lines.find { |line| line.strip.start_with? 'Finished:' }
    f = found.split('Finished:')[1].strip
    # '2017-11-04 08:55:32'
    built_on = DateTime.parse(f)
    ago = TimeDifference.between(built_on, DateTime.now).humanize
    # '22 Hours, 36 Minutes and 28 Seconds' => '22 Hours'
    # '23 Hours and 53 Seconds' => '23 Hours'
    '~' + ago.split(',')[0].split('and')[0].strip + ' ago'
  end

  def took(lines)
    # Duration: 1 min 38 sec
    found = lines.find { |line| line.strip.start_with? 'Duration:' }
    found.split(':')[1].strip # '1 min 38 sec'
  end

  include AssertSystem

  def service_repos
    %w( collector
        commander
        differ
        grafana
        nginx
        prometheus
        runner_processful
        runner_stateful
        runner_stateless
        storer
        system-tests
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
