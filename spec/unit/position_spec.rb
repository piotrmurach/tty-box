# frozen_string_literal: true

RSpec.describe TTY::Box, ":top, :left options" do
  it "skips positioning when no top & left values provided" do
    box = TTY::Box.new(width: 35, height: 4)

    expect(box.top).to eq(nil)
    expect(box.left).to eq(nil)
    expect(box.position?).to eq(false)

    expect(box.render).to eq([
      "┌─────────────────────────────────┐\n",
      "│                                 │\n",
      "│                                 │\n",
      "└─────────────────────────────────┘\n"
    ].join)
  end

  it "allows to absolutely position within the terminal window" do
    box = TTY::Box.new(top: 10, left: 40, width: 35, height: 4)

    expect(box.top).to eq(10)
    expect(box.left).to eq(40)
    expect(box.position?).to eq(true)

    expect(box.render).to eq([
      "\e[11;41H┌─────────────────────────────────┐",
      "\e[12;41H│\e[12;75H│",
      "\e[13;41H│\e[13;75H│",
      "\e[14;41H└─────────────────────────────────┘"
    ].join)
  end
end
