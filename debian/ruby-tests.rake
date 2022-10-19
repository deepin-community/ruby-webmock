require "rspec/core/rake_task"
require "rspec"

ENV["NO_CONNECTION"]="true"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  t.pattern = FileList["spec/**/*_spec.rb"].exclude("spec/acceptance/patron/*").exclude('spec/quality_spec.rb').exclude('spec/acceptance/async_http_client/*').exclude('spec/acceptance/excon/excon_spec.rb').exclude('spec/acceptance/http_rb/http_rb_spec.rb')
end

RSpec::Core::RakeTask.new(:spec_http_without_webmock) do |t|
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/acceptance/net_http/real_net_http_spec.rb"]
  t.pattern = 'spec/acceptance/net_http/real_net_http_spec.rb'
end

RSpec.configure do |config|
  config.filter_run_excluding :without_webmock => true
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList["test/**/*.rb"].exclude("test/test_helper.rb")
  test.verbose = false
  test.warning = false
end

Rake::TestTask.new(:minitest) do |test|
  test.test_files = FileList["minitest/**/*.rb"].exclude("test/test_helper.rb")
  test.verbose = false
  test.warning = false
end


task :default => [:spec, :spec_http_without_webmock, :test, :minitest]
