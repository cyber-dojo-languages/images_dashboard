require 'sinatra/base'
require 'json'
require_relative 'assert_system'

# https://docs.travis-ci.com/api

class ImagesDashboard < Sinatra::Base

  get '/languages/index' do
    @json = curled_triples.select { |repo_name| repo_name =~ /\d/ }
    @json.delete('bash-shunit2')
    erb :languages_index
  end

  # - - - - - - - - - - - - - - -

  get '/test_framework/index' do
    @json = curled_triples.select { |repo_name|
      (repo_name == 'bash-shunit2') ||
        !(repo_name =~ /\d/)
    }
    @json.delete('elm-test-bad-manifest-for-testing')
    erb :test_framework_index
  end

  # - - - - - - - - - - - - - - -

  get '/' do
    @json = curled_triples

    assert_system "travis login --skip-completion-check --github-token ${GITHUB_TOKEN}"
    token = assert_backtick('travis token --org').strip
    assert_system 'travis logout'

    @repo = 'rust-test' # one of @json.keys
    @log = assert_backtick "travis logs --skip-completion-check --org --token #{token} --repo #{cdl}/#{@repo}"
    lines = @log.split("\n")
    @passed = lines[-1].include? 'Done. Your build exited with 0.'

    n = lines.index('# print_date_time')
    @date = lines[n+1]
    @duration = lines[n+2][7..-1]

    n = lines.index('# print_image_info')
    @size = lines[n+1].split[-2..-1].join(' ')
    words = lines[n+2].split
    n = words.index('Alpine') || words.index('Ubuntu')
    @os = words[n..-1].join(' ')

    # test-framework only
    n = lines.index('# check_start_point_src_red_green_amber_using_runner_stateless')
    @red   = lines[n+1][12..-2]
    @green = lines[n+2][14..-2]
    @amber = lines[n+3][14..-2]

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
