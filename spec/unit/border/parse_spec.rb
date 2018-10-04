# frozen_string_literal: true

RSpec.describe TTY::Box::Border, '.parse' do
  it "parses default border" do
    border = TTY::Box::Border.parse({})

    actual = [border.type, border.top, border.right, border.bottom, border.left]

    expect(actual).to eq([:light, :line, :pipe, :line, :pipe])
  end

  it "parses only border type" do
    border = TTY::Box::Border.parse(:thick)

    actual = [border.type, border.top, border.right, border.bottom, border.left]

    expect(actual).to eq([:thick, :line, :pipe, :line, :pipe])
  end

  it "parses custom border" do
    border = TTY::Box::Border.parse({
      top: true,
      top_left: :cross,
      top_right: :cross,
      bottom: true,
      bottom_left: :cross,
      bottom_right: :cross
    })

    top_border = [border.top_left, border.top, border.top_right]
    bottom_border = [border.bottom_left, border.bottom, border.bottom_right]

    expect(border.type).to eq(:light)
    expect(top_border).to eq([:cross, true, :cross])
    expect(bottom_border).to eq([:cross, true, :cross])
  end
end
