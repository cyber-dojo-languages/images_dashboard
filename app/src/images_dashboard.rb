require 'sinatra/base'
require 'json'
require 'time_difference'
require_relative 'assert_system'

class ImagesDashboard < Sinatra::Base

  get '/' do
    @json = curled_triples
    @services = service_repos
    @languages = @json.select { |repo,hash| hash['test_framework'] == false }
    @test_frameworks = @json.select { |repo,hash| hash['test_framework'] === true }
    @tools = [ 'image_builder' ]
    erb :home
  end

  # - - - - - - - - - - - - - - -

  get '/build' do
    # TODO: put failing tests at top of table,
    # rest alphabetically underneath.

    content_type :json
    org = params[:org]
    repo = params[:repo]
    # https://docs.travis-ci.com/api
    info = `travis show --org --skip-completion-check --repo #{org}/#{repo}`
    begin
      lines = info.split("\n")
      { :state => state(lines),
        :age => age(lines),
        :took => took(lines)
      }.to_json
    rescue Exception => e
      { :state => lines.join('<br/>') + '<br/>' + e.message,
        :age => '?',
        :took => '?'
      }.to_json
    end
  end

  # - - - - - - - - - - - - - - -

  private

  def state(lines)
    # 'State: passed|failed|started'
    found = lines.find { |line| line.strip.start_with? 'State:' }
    found.split(':')[1].strip # 'passed'
  end

  def age(lines)
    # Finished: 2017-11-04 08:55:32
    found = lines.find { |line| line.strip.start_with? 'Finished:' }
    finished = found.split('Finished:')[1].strip
    if finished == 'not yet'
      '...'
    else
      # '2017-11-04 08:55:32'
      built_on = DateTime.parse(finished)
      ago = TimeDifference.between(built_on, DateTime.now).humanize
      # '22 Hours, 36 Minutes and 28 Seconds' => '22 Hours'
      # '23 Hours and 53 Seconds' => '23 Hours'
      ago.split(',')[0].split('and')[0].strip
    end
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
