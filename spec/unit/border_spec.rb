RSpec.describe TTY::Box, ':border option' do
  it "creates frame with double lines" do
    output = TTY::Box.frame(
      top: 0, left: 0,
      width: 35, height: 4,
      border: :thick
    )

    expect(output).to eq([
      "\e[1;1H╔═════════════════════════════════╗",
      "\e[2;1H║\e[2;35H║\e[3;1H║\e[3;35H║",
      "\e[4;1H╚═════════════════════════════════╝"
    ].join)
  end
end
