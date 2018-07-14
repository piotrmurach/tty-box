RSpec.describe TTY::Box, ':top, :left options' do
  it "allows to absolutely position within the terminal window" do
    output = TTY::Box.frame(top: 10, left: 40, width: 35, height: 4)

    expect(output).to eq([
      "\e[11;41H┌─────────────────────────────────┐",
      "\e[12;41H│\e[12;75H│\e[13;41H│\e[13;75H│",
      "\e[14;41H└─────────────────────────────────┘"
    ].join)
  end
end
