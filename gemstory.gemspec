
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gemstory/version'

Gem::Specification.new do |spec|
  spec.name          = 'gemstory'
  spec.version       = Gemstory::VERSION
  spec.authors       = ['Edwin Rozario']
  spec.email         = ['rozarioed@gmail.com']

  spec.summary       = %q{CLI tool to map the history of your gems in a project}
  spec.description   = %q{Version changes of all the Gems in a project that has a Gemfile.lock is tracked through time}
  spec.homepage      = "https://github.com/EdwinRozario/gemstory"
  spec.license       = 'MIT'

  spec.default_executable = 'gemstory'
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  # spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  #spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'
  spec.add_dependency 'progress'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.7'
end
 