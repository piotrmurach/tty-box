# frozen_string_literal: true

RSpec.describe TTY::Box, ".new" do
  it "calculates dimensions for a box with border and single line content" do
    box = TTY::Box.new("Hello world")

    expect(box.width).to eq(13)
    expect(box.height).to eq(3)
    expect(box.content_width).to eq(11)
    expect(box.content_height).to eq(1)

    expect(box.render).to eq([
      "┌───────────┐\n",
      "│Hello world│\n",
      "└───────────┘\n"
    ].join)
  end

  it "calculates dimensions for a box with border and multiline content" do
    box = TTY::Box.new("Hello\nnew\nworld")

    expect(box.width).to eq(7)
    expect(box.height).to eq(5)
    expect(box.content_width).to eq(5)
    expect(box.content_height).to eq(3)

    expect(box.render).to eq([
      "┌─────┐\n",
      "│Hello│\n",
      "│new  │\n",
      "│world│\n",
      "└─────┘\n"
    ].join)
  end

  it "calculates dimensions for a box with padding and multiline content" do
    box = TTY::Box.new("Hello\nnew\nworld", padding: [1, 2])

    expect(box.width).to eq(11)
    expect(box.height).to eq(7)
    expect(box.content_width).to eq(5)
    expect(box.content_height).to eq(3)

    expect(box.render).to eq([
      "┌─────────┐\n",
      "│         │\n",
      "│  Hello  │\n",
      "│  new    │\n",
      "│  world  │\n",
      "│         │\n",
      "└─────────┘\n"
    ].join)
  end

  it "calculates dimensions for a box with padding and wrapped content" do
    box = TTY::Box.new("Hello new world", width: 12, padding: [1, 2])

    expect(box.width).to eq(12)
    expect(box.height).to eq(7)
    expect(box.content_width).to eq(6)
    expect(box.content_height).to eq(3)

    expect(box.render).to eq([
      "┌──────────┐\n",
      "│          │\n",
      "│  Hello   │\n",
      "│  new     │\n",
      "│  world   │\n",
      "│          │\n",
      "└──────────┘\n"
    ].join)
  end

  it "calculates box dimensions without border" do
    no_border = {top: false, left: false, right: false, bottom: false}
    box = TTY::Box.new("Hello world", border: no_border)

    expect(box.width).to eq(11)
    expect(box.height).to eq(1)
    expect(box.content_width).to eq(11)
    expect(box.content_height).to eq(1)

    expect(box.render).to eq([
      "Hello world\n"
    ].join)
  end
end
