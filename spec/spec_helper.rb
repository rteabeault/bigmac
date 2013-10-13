begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rspec'
require 'tempfile'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'bigmac'
require 'fakefs/spec_helpers'
require 'fakefs/safe'
require 'webmock/rspec'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.color_enabled = true
  
  config.before(:suite) do
    BigMac.ui.mute!
  end

  config.after(:suite) do
    BigMac.ui.unmute!
  end
end

def create_cookbook_project(destination)
  files = []
  FileUtils.mkdir_p(destination)

  files << File.open(File.join(destination, 'metadata.rb'), 'w+') do |file|
    file.write("metadata")
  end

  files << File.open(File.join(destination, 'Berksfile'), 'w+') do |file|
    file.write("Berksfile")
  end

  files
end

def create_bigmac_project(destination, roles=[:default])
  files = []

  FileUtils.mkdir_p(destination)
  FileUtils.mkdir_p(File.join(destination, '.bigmac'))

  files << File.open(File.join(destination, '.bigmac', 'Berksfile'), 'w+') do |file|
    file.write("Berksfile")
  end

  unless roles.empty?
    FileUtils.mkdir_p(File.join(destination, '.bigmac', 'roles'))
    roles.each do |role|
      role_name = role.to_s
      role_path = File.join(destination, '.bigmac', 'roles', "#{role_name}.rb")
      files << File.open(role_path, 'w+') do |file|
        file.write(role_name)
      end
    end
  end

  files
end