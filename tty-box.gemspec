lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tty/box/version"

Gem::Specification.new do |spec|
  spec.name          = "tty-box"
  spec.version       = TTY::Box::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = [""]

  spec.summary       = %q{Draw various frames and boxes in your terminal interface.}
  spec.description   = %q{Draw various frames and boxes in your terminal interface.}
  spec.homepage      = "https://piotrmurach.github.io/tty"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'pastel', '~> 0.7.2'
  spec.add_dependency 'tty-cursor', '~> 0.6.0'
  spec.add_dependency 'strings', '~> 0.1.1'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
