require 'thor'
require 'thor/monkey/shell'
require 'bigmac/version'
require 'bigmac/errors'

module BigMac
  autoload :CLI,                 'bigmac/cli'
  autoload :UI,                  'bigmac/ui'
  autoload :Mixin,               'bigmac/mixins'
  autoload :GithubKeychain,      'bigmac/util/github_keychain'
  autoload :OS,                  'bigmac/os'
  autoload :Prerequisites,       'bigmac/prerequisites'
  autoload :ProjectSource,       'bigmac/project_source'
  autoload :GitSource,           'bigmac/sources/git_source'
  autoload :GithubSource,        'bigmac/sources/github_source'
  autoload :PathSource,          'bigmac/sources/path_source'
  autoload :Installer,           'bigmac/installer'
  autoload :Downloader,          'bigmac/util/downloader'
  autoload :ChefSolo,            'bigmac/util/chef_solo'
  autoload :Dmg,                 'bigmac/util/dmg'
  autoload :DmgInstaller,        'bigmac/util/dmg_installer'
  autoload :Berks,               'bigmac/util/berkshelf'
  autoload :Git,                 'bigmac/util/git'
  autoload :Github,              'bigmac/util/github'
  autoload :GithubAPI,           'bigmac/util/github_api'
  autoload :Project,             'bigmac/project'
  autoload :BigMacProject,       'bigmac/projects/bigmac_project'
  autoload :CookbookProject,     'bigmac/projects/cookbook_project'
  autoload :CookbookRepoProject, 'bigmac/projects/cookbook_repo_project'

  Thor::Base.shell.send(:include, BigMac::UI)

  BUNDLER_PRESENT = ENV.key? 'BUNDLE_GEMFILE'
  if BUNDLER_PRESENT
    require 'bundler'
  end

  class << self
    def executable_name
      File.basename($PROGRAM_NAME)
    end

    def bigmac_dir
      File.expand_path('~/.bigmac')
    end

    def cache_dir
      "#{bigmac_dir}/cache"
    end

    def repositories_dir
      "#{cache_dir}/repos"
    end

    def vendor_cookbooks
      "#{bigmac_dir}/vendor/cookbooks"
    end

    def ui
      @ui ||= Thor::Base.shell.new
    end
  end
end