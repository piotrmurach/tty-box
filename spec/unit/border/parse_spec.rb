# frozen_string_literal: true

RSpec.describe TTY::Box::Border, ".parse" do
  it "parses default border" do
    border = TTY::Box::Border.parse({})
    top_border = [border.top_left, border.top, border.top_right]
    bottom_border = [border.bottom_left, border.bottom, border.bottom_right]

    expect(border.type).to eq(:light)
    expect(top_border).to eq(%i[corner_top_left line corner_top_right])
    expect(bottom_border).to eq(%i[corner_bottom_left line corner_bottom_right])
    expect(border.left).to eq(:pipe)
    expect(border.right).to eq(:pipe)
  end

  it "parses only border type" do
    border = TTY::Box::Border.parse(:thick)
    top_border = [border.top_left, border.top, border.top_right]
    bottom_border = [border.bottom_left, border.bottom, border.bottom_right]

    expect(border.type).to eq(:thick)
    expect(top_border).to eq(%i[corner_top_left line corner_top_right])
    expect(bottom_border).to eq(%i[corner_bottom_left line corner_bottom_right])
    expect(border.left).to eq(:pipe)
    expect(border.right).to eq(:pipe)
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

  it "parses divider values" do
    border = TTY::Box::Border.parse({
      top_left: :divider_right,
      top_right: :divider_left,
      bottom_left: :divider_down,
      bottom_right: :divider_up
    })

    top_border = [border.top_left, border.top, border.top_right]
    bottom_border = [border.bottom_left, border.bottom, border.bottom_right]

    expect(border.type).to eq(:light)
    expect(top_border).to eq(%i[divider_right line divider_left])
    expect(bottom_border).to eq(%i[divider_down line divider_up])
  end

  it "defaults border size to one" do
    border = TTY::Box::Border.parse({})

    expect(border.top_size).to eq(1)
    expect(border.bottom_size).to eq(1)
    expect(border.left_size).to eq(1)
    expect(border.right_size).to eq(1)
  end

  it "returns zero size for no border" do
    border = TTY::Box::Border.parse({
      top: false,
      left: false,
      right: false,
      bottom: false
    })

    expect(border.top_size).to eq(0)
    expect(border.left_size).to eq(0)
    expect(border.right_size).to eq(0)
    expect(border.bottom_size).to eq(0)
  end
end
