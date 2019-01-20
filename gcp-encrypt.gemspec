lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gcp_encrypt/version'

Gem::Specification.new do |spec|
  spec.name          = 'gcp-encrypt'
  spec.version       = GcpEncrypt::VERSION
  spec.authors       = ['Carlos Reyna']
  spec.email         = ['support@reynatechnologies.com']

  spec.summary       = 'Simple tool to help manage the encryption of files'
  spec.description   = ''
  spec.homepage      = 'https://www.reynatechnologies.com/'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #
  #   spec.metadata['homepage_uri'] = spec.homepage
  #   spec.metadata['source_code_uri'] = "TODO: Put your gem's public repo URL here."
  #   spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."
  # else
  #   raise 'RubyGems 2.0 or newer is required to protect against ' \
  #     'public gem pushes.'
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been
  # added into git.
  spec.files = %w(
    Gemfile
    Gemfile.lock
    LICENSE.txt
    README.md
    Rakefile
    exe/gcp-encrypt
    gcp-encrypt.gemspec
    lib/gcp_encrypt.rb
    lib/gcp_encrypt/version.rb
    template/config.yml
  )
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop-airbnb', '~> 2.0'
  spec.add_development_dependency 'byebug', '~> 10.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.6'
end
