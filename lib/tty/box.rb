# frozen_string_literal: true

require 'strings'
require 'pastel'
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

    def color
      @color ||= Pastel.new
    end

    # Create a frame
    #
    # @api public
    def frame(top: 0, left: 0, width: 35, height: 3, title: {}, border: :light, style: {})
      output = []
      content = []

      if block_given?
        wrapped = Strings.wrap(yield, width - 2)
        content = wrapped.split("\n")
      end

      fg, bg = *extract_style(style)
      border_fg, border_bg = *extract_style(style[:border] || {})

      output << cursor.move_to(left, top)
      output << top_border(title, width, border, style)
      (height - 2).times do |i|
        output << cursor.move_to(left, top + i + 1)
        output << border_bg.(border_fg.(pipe_char(border)))
        if content[i].nil?
          output << bg.(fg.(' ' * (width - 2))) if style[:fg] || style[:bg]
        else
          output << bg.(fg.(content[i]))
          if style[:fg] || style[:bg]
            output << bg.(fg.(' ' * (width - 2 - content[i].size)))
          end
        end
        output << cursor.move_to(left + width - 1, top + i + 1)
        output << border_bg.(border_fg.(pipe_char(border)))
      end
      output << cursor.move_to(left, top + height - 1)
      output << bottom_border(title, width, border, style)

      output.join
    end

    # Convert style keywords into styling
    #
    # @return [Array[Proc, Proc]]
    #
    # @api private
    def extract_style(style)
      fg = style[:fg] ? color.send(style[:fg]).detach : -> (c) { c }
      bg = style[:bg] ? color.send(:"on_#{style[:bg]}").detach : -> (c) { c }
      [fg, bg]
    end

    # Top border
    #
    # @return [String]
    #
    # @api private
    def top_border(title, width, border, style)
      top_titles_size = title[:top_left].to_s.size +
                        title[:top_center].to_s.size +
                        title[:top_right].to_s.size
      fg, bg = *extract_style(style[:border] || {})

      top_space_left = width - top_titles_size -
                       top_left_char.size - top_right_char.size
      top_space_before = top_space_left / 2
      top_space_after = top_space_left / 2 + top_space_left % 2

      [
        bg.(fg.(top_left_char(border))),
        bg.(title[:top_left].to_s),
        bg.(fg.(line_char(border) * top_space_before)),
        bg.(title[:top_center].to_s),
        bg.(fg.(line_char(border) * top_space_after)),
        bg.(title[:top_right].to_s),
        bg.(fg.(top_right_char(border)))
      ].join('')
    end

    # Bottom border
    #
    # @return [String]
    #
    # @api private
    def bottom_border(title, width, border, style)
      bottom_titles_size = title[:bottom_left].to_s.size +
                           title[:bottom_center].to_s.size +
                           title[:bottom_right].to_s.size
      fg, bg = *extract_style(style[:border] || {})

      bottom_space_left = width - bottom_titles_size -
                          bottom_left_char.size - bottom_right_char.size
      bottom_space_before = bottom_space_left / 2
      bottom_space_after = bottom_space_left / 2 + bottom_space_left % 2

      [
        bg.(fg.(bottom_left_char(border))),
        bg.(title[:bottom_left].to_s),
        bg.(fg.(line_char(border) * bottom_space_before)),
        bg.(title[:bottom_center].to_s),
        bg.(fg.(line_char(border) * bottom_space_after)),
        bg.(title[:bottom_right].to_s),
        bg.(fg.(bottom_right_char(border)))
      ].join('')
    end
  end # TTY
end # Box
