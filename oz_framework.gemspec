lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rest_dsl/version'

Gem::Specification.new do |spec|
  spec.name          = 'rest_dsl'
  spec.version       = RestDSL::VERSION
  spec.authors       = ['Donny Bush', 'Luke Ridge', 'Shadd Parker', 'Uriah Brown']
  spec.email         = ['', 'lzridge.04@gmail.com', '', '']

  spec.summary       = %q{A powerful testing framework written in ruby.}
  spec.homepage      = 'https://github.com/ozframework/oz'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/ozframework/oz'
    spec.metadata['changelog_uri'] = 'https://github.com/ozframework/oz'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'httpi', '2.4.4'
  spec.add_development_dependency 'json', '~> 2.2.0'
  spec.add_development_dependency 'psych', '~> 3.1.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_runtime_dependency 'cucumber', '~> 3.0'
  spec.add_runtime_dependency 'watir', '~> 6.16.5'

end
