source "https://rubygems.org"

gemspec

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.1.0")
  gem "rspec-benchmark", "~> 0.6"
end

group :test do
  gem "benchmark-ips", "~> 2.8.4"
  gem "simplecov", "~> 0.16.1"
  gem "coveralls", "~> 0.8.23"
end

group :metrics do
  gem "yardstick", "~> 0.9.9"
end
