RSpec.describe TTY::Box, '#frame' do
  it "creates frame with only  width & height values" do
    output = TTY::Box.frame(width: 35, height: 4)

    expect(output).to eq([
      "┌─────────────────────────────────┐\n",
      "│                                 │\n",
      "│                                 │\n",
      "└─────────────────────────────────┘\n"
    ].join)
  end

  it "creates frame at a position with direct width & height values" do
    output = TTY::Box.frame(top: 0, left: 0, width: 35, height: 4)

    expect(output).to eq([
      "\e[1;1H┌─────────────────────────────────┐",
      "\e[2;1H│\e[2;35H│",
      "\e[3;1H│\e[3;35H│",
      "\e[4;1H└─────────────────────────────────┘"
    ].join)
  end

  it "displays content when block provided" do
    output = TTY::Box.frame(top: 0, left: 0, width: 35, height: 4) do
      "Hello world!"
    end

    expect(output).to eq([
      "\e[1;1H┌─────────────────────────────────┐",
      "\e[2;1H│Hello world!                     \e[2;35H│",
      "\e[3;1H│\e[3;35H│",
      "\e[4;1H└─────────────────────────────────┘"
    ].join)
  end

  it "wraps content when exceeding width" do
    box = TTY::Box.frame(top: 0, left: 0, width: 20, height: 4) do
      "Drawing a box in terminal emulator"
    end

    expect(box).to eq([
      "\e[1;1H┌──────────────────┐",
      "\e[2;1H│Drawing a box in  \e[2;20H│",
      "\e[3;1H│terminal emulator \e[3;20H│",
      "\e[4;1H└──────────────────┘"
    ].join)
  end
end
