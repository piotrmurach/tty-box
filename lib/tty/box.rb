# frozen_string_literal: true

require 'tty-cursor'

require_relative 'box/version'

module TTY
  module Box
    module_function

    BOX_CHARS = {
      light: %w[┘ ┐ ┌ └ ┤ ┴ ┬ ├ ─ │ ┼],
      thick: %w[╝ ╗ ╔ ╚ ╣ ╩ ╦ ╠ ═ ║ ╬]
    }.freeze

    def line_char(border = :light)
      BOX_CHARS[border][8]
    end

    def pipe_char(border = :light)
      BOX_CHARS[border][9]
    end

    def cross_char(border = :light)
      BOX_CHARS[border][10]
    end

    def left_divider_char(border = :light)
      BOX_CHARS[border][7]
    end

    def right_divider_char(border = :light)
      BOX_CHARS[border][4]
    end

    def top_left_char(border = :light)
      BOX_CHARS[border][2]
    end

    def top_divider_char(border = :light)
      BOX_CHARS[border][6]
    end

    def top_right_char(border = :light)
      BOX_CHARS[border][1]
    end

    def bottom_left_char(border = :light)
      BOX_CHARS[border][3]
    end

    def bottom_divider_char(border = :light)
      BOX_CHARS[border][5]
    end

    def bottom_right_char(border = :light)
      BOX_CHARS[border][0]
    end

    def cursor
      TTY::Cursor
    end

    def frame(top: 0, left: 0, title: {}, width: 35, height: 3, border: :light)
      output = []
      content = []
      content = yield.split("\n") if block_given?

      output << cursor.move_to(left, top)
      output << top_border(title, width, border)
      (height - 2).times do |i|
        output << cursor.move_to(left, top + i + 1)
        output << pipe_char(border)
        output << content[i]
        output << cursor.move_to(left + width - 1, top + i + 1)
        output << pipe_char(border)
      end
      output << cursor.move_to(left, top + height - 1)
      output << bottom_border(title, width, border)

      output.join
    end

    def top_border(title, width, border)
      top_titles_size = title[:top_left].to_s.size +
                        title[:top_center].to_s.size +
                        title[:top_right].to_s.size


      top_space_left = width - top_titles_size -
                       top_left_char.size - top_right_char.size
      top_space_before = top_space_left / 2
      top_space_after = top_space_left / 2 + top_space_left % 2

      [
        top_left_char(border),
        title[:top_left].to_s,
        line_char(border) * top_space_before,
        title[:top_center].to_s,
        line_char(border) * top_space_after,
        title[:top_right].to_s,
        top_right_char(border)
      ].join('')
    end

    def bottom_border(title, width, border)
      bottom_titles_size = title[:bottom_left].to_s.size +
                           title[:bottom_center].to_s.size +
                           title[:bottom_right].to_s.size

      bottom_space_left = width - bottom_titles_size -
                          bottom_left_char.size - bottom_right_char.size
      bottom_space_before = bottom_space_left / 2
      bottom_space_after = bottom_space_left / 2 + bottom_space_left % 2

      [
        bottom_left_char(border),
        title[:bottom_left].to_s,
        line_char(border) * bottom_space_before,
        title[:bottom_center].to_s,
        line_char(border) * bottom_space_after,
        title[:bottom_right].to_s,
        bottom_right_char(border)
      ].join('')
    end
  end # TTY
end # Box
