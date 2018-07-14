RSpec.describe TTY::Box, ":style option" do
  it "applies styling to content and border" do
    box = TTY::Box.frame(
      width: 30,
      height: 4,
      border: :thick,
      title: {
        top_left: ' file1 '
      },
      style: {
        fg: :bright_yellow,
        bg: :blue,
        border: {
          fg: :bright_yellow,
          bg: :blue
        }
      }
    ) do
      "Midnight Commander\n is the best"
    end

    expect(box).to eq([
      "\e[1;1H\e[44m\e[93m╔\e[0m\e[0m\e[44m file1 \e[0m\e[44m\e[93m══════════\e[0m\e[0m\e[44m\e[93m═══════════\e[0m\e[0m\e[44m\e[93m╗\e[0m\e[0m",
      "\e[2;1H\e[44m\e[93m║\e[0m\e[0m\e[44m\e[93mMidnight Commander\e[0m\e[0m\e[44m\e[93m          \e[0m\e[0m\e[2;30H\e[44m\e[93m║\e[0m\e[0m",
      "\e[3;1H\e[44m\e[93m║\e[0m\e[0m\e[44m\e[93m is the best\e[0m\e[0m\e[44m\e[93m                \e[0m\e[0m\e[3;30H\e[44m\e[93m║\e[0m\e[0m",
      "\e[4;1H\e[44m\e[93m╚\e[0m\e[0m\e[44m\e[93m══════════════\e[0m\e[0m\e[44m\e[93m══════════════\e[0m\e[0m\e[44m\e[93m╝\e[0m\e[0m"
    ].join)
  end
end
