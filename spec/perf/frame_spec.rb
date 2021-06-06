# frozen_string_literal: true

require "rspec-benchmark"
require "yaml"

RSpec.describe TTY::Box do
  include RSpec::Benchmark::Matchers

  let(:output) { StringIO.new }

  it "displays box 12.5x slower than YAML output" do
    content = "Hello World"

    expect {
      TTY::Box.frame(content)
    }.to perform_slower_than {
      YAML.dump(content)
    }.at_most(12.5).times
  end

  it "displays box allocating no more than 423 objects" do
    content = "Hello World"

    expect {
      TTY::Box.frame(content)
    }.to perform_allocation(423).objects
  end
end
