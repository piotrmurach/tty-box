RSpec.describe TTY::Box, ':align option' do
  it "aligns content with the option" do
    box = TTY::Box.frame(width: 26, height: 4, align: :center) do
      "Drawing a box in terminal emulator"
    end

    expect(box).to eq([
      "\e[1;1H┌────────────────────────┐",
      "\e[2;1H│   Drawing a box in     \e[2;26H│",
      "\e[3;1H│   terminal emulator    \e[3;26H│",
      "\e[4;1H└────────────────────────┘"
    ].join)
  end
end
