require_relative "lib/tty/box/version"

Gem::Specification.new do |spec|
  spec.name          = "tty-box"
  spec.version       = TTY::Box::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = ["piotr@piotrmurach.com"]
  spec.summary       = %q{Draw various frames and boxes in your terminal interface.}
  spec.description   = %q{Draw various frames and boxes in your terminal interface.}
  spec.homepage      = "https://piotrmurach.github.io/tty"
  spec.license       = "MIT"
  if spec.respond_to?(:metadata=)
    spec.metadata = {
      "allowed_push_host" => "https://rubygems.org",
      "bug_tracker_uri"   => "https://github.com/piotrmurach/tty-box/issues",
      "changelog_uri"     => "https://github.com/piotrmurach/tty-box/blob/master/CHANGELOG.md",
      "documentation_uri" => "https://www.rubydoc.info/gems/tty-box",
      "homepage_uri"      => spec.homepage,
      "source_code_uri"   => "https://github.com/piotrmurach/tty-box"
    }
  end
  spec.files         = Dir["lib/**/*"]
  spec.extra_rdoc_files = ["README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.0.0"

  spec.add_dependency "pastel", "~> 0.8"
  spec.add_dependency "tty-cursor", "~> 0.7"
  #spec.add_dependency "strings", "~> 0.1.6"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0"
end
