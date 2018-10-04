# frozen_string_literal: true

RSpec.describe TTY::Box::Border, '.parse' do
  it "parses default border" do
    border = TTY::Box::Border.parse({})

    actual = [border.type, border.top, border.right, border.bottom, border.left]

    expect(actual).to eq([:light, true, true, true, true])
  end

  it "parses only border type" do
    border = TTY::Box::Border.parse(:thick)

    actual = [border.type, border.top, border.right, border.bottom, border.left]

    expect(actual).to eq([:thick, true, true, true, true])
  end
end
