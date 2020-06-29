# frozen_string_literal: true

RSpec.describe TTY::Box, ':title option' do
  it "allows to specify top border titles"  do
    output = TTY::Box.frame(
      top: 0, left: 0,
      width: 35, height: 4,
      title: {
        top_left: 'left',
        top_right: 'right',
        top_center: 'center'
      })

    expect(output).to eq([
      "\e[1;1H┌left─────────center─────────right┐",
      "\e[2;1H│\e[2;35H│\e[3;1H│\e[3;35H│",
      "\e[4;1H└─────────────────────────────────┘"
    ].join)
  end

  it "allows to specify bottom border titles"  do
    output = TTY::Box.frame(
      top: 0, left: 0,
      width: 35, height: 4,
      title: {
        bottom_left: 'left',
        bottom_right: 'right',
        bottom_center: 'center'
      })

    expect(output).to eq([
      "\e[1;1H┌─────────────────────────────────┐",
      "\e[2;1H│\e[2;35H│\e[3;1H│\e[3;35H│",
      "\e[4;1H└left─────────center─────────right┘"
    ].join)
  end

  it "allows the top title to be longer than the message" do
    output = TTY::Box.frame("BOO!",
                            title: {
                              top_left: " ⚠ WARNING ",
                            })

    expect(output).to eq([
      "┌ ⚠ WARNING ┐\n",
      "│BOO!       │\n",
      "└───────────┘\n"
    ].join)
  end

  it "allows the bottom title to be longer than the message" do
    output = TTY::Box.frame("BOO!",
                            title: {
                              bottom_left: " ⚠ WARNING "
                            })

    expect(output).to eq([
      "┌───────────┐\n",
      "│BOO!       │\n",
      "└ ⚠ WARNING ┘\n"
    ].join)
  end
end
