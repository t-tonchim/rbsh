
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rbshell/version"

Gem::Specification.new do |spec|
  spec.name          = "rbshell"
  spec.version       = Rbshell::VERSION
  spec.authors       = ["t-tonchim"]
  spec.email         = ["masuminium5@gmail.com"]

  spec.summary       = "UNIX Shell implements by Ruby."
  spec.description   = "UNIX Shell implements by Ruby. But this gem has not sufficient feature."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
