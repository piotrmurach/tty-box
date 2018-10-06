# frozen_string_literal: true

require 'strings'
require 'pastel'
require 'tty-cursor'

require_relative 'box/border'
require_relative 'box/version'

module TTY
  module Box
    module_function

    BOX_CHARS = {
      light: %w[┘ ┐ ┌ └ ┤ ┴ ┬ ├ ─ │ ┼],
      thick: %w[╝ ╗ ╔ ╚ ╣ ╩ ╦ ╠ ═ ║ ╬]
    }.freeze

    def corner_bottom_right_char(border = :light)
      BOX_CHARS[border][0]
    end

    def corner_top_right_char(border = :light)
      BOX_CHARS[border][1]
    end

    def corner_top_left_char(border = :light)
      BOX_CHARS[border][2]
    end

    def corner_bottom_left_char(border = :light)
      BOX_CHARS[border][3]
    end

    def divider_left_char(border = :light)
      BOX_CHARS[border][4]
    end

    def divider_up_char(border = :light)
      BOX_CHARS[border][5]
    end

    def divider_down_char(border = :light)
      BOX_CHARS[border][6]
    end

    def divider_right_char(border = :light)
      BOX_CHARS[border][7]
    end

    def line_char(border = :light)
      BOX_CHARS[border][8]
    end

    def pipe_char(border = :light)
      BOX_CHARS[border][9]
    end

    def cross_char(border = :light)
      BOX_CHARS[border][10]
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
    def frame(top: nil, left: nil, width: 35, height: 3, align: :left, padding: 0,
              title: {}, border: :light, style: {})
      output = []
      content = []
      position = top && left

      border = Border.parse(border)
      left_size  = border.left? ? 1 : 0
      right_size = border.right ? 1 : 0

      if block_given?
        content = format(yield, width, padding, align)
      end

      fg, bg = *extract_style(style)
      border_fg, border_bg = *extract_style(style[:border] || {})

      if border.top?
        output << cursor.move_to(left, top) if position
        output << top_border(title, width, border, style)
        output << "\n" unless position
      end

      (height - 2).times do |i|
        output << cursor.move_to(left, top + i + 1) if position
        if border.left?
          output << border_bg.(border_fg.(pipe_char(border.type)))
        end
        if content[i].nil? && (style[:fg] || style[:bg] || !position)
          content_size = width - left_size - right_size
          output << bg.(fg.(' ' * content_size))
        else
          output << bg.(fg.(content[i]))
          if style[:fg] || style[:bg]
            content_size = width - left_size - right_size - content[i].size
            output << bg.(fg.(' ' * content_size))
          end
        end
        if border.right?
          output << cursor.move_to(left + width - 1, top + i + 1) if position
          output << border_bg.(border_fg.(pipe_char(border.type)))
        end
        output << "\n" unless position
      end

      if border.bottom?
        output << cursor.move_to(left, top + height - 1) if position
        output << bottom_border(title, width, border, style)
        output << "\n" unless position
      end

      output.join
    end

    # Format content
    #
    # @return [Array[String]]
    #
    # @api private
    def format(content, width, padding, align)
      pad = Strings::Padder.parse(padding)
      total_width = width - 2 - (pad.left + pad.right)

      wrapped = Strings.wrap(content, total_width)
      aligned = Strings.align(wrapped, total_width, direction: align)
      padded  = Strings.pad(aligned, padding)
      padded.split("\n")
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

      top_left = border.top_left? && border.left? ? send(:"#{border.top_left}_char", border.type) : ""
      top_right = border.top_right? && border.right? ? send(:"#{border.top_right}_char", border.type) : ""

      top_space_left   = width - top_titles_size - top_left.size - top_right.size
      top_space_before = top_space_left / 2
      top_space_after  = top_space_left / 2 + top_space_left % 2

      [
        bg.(fg.(top_left)),
        bg.(title[:top_left].to_s),
        bg.(fg.(line_char(border.type) * top_space_before)),
        bg.(title[:top_center].to_s),
        bg.(fg.(line_char(border.type) * top_space_after)),
        bg.(title[:top_right].to_s),
        bg.(fg.(top_right))
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

      bottom_left  = border.bottom_left? && border.left? ? send(:"#{border.bottom_left}_char", border.type) : ""
      bottom_right = border.bottom_right? && border.right? ? send(:"#{border.bottom_right}_char", border.type) : ""

      bottom_space_left = width - bottom_titles_size -
                          bottom_left.size - bottom_right.size
      bottom_space_before = bottom_space_left / 2
      bottom_space_after = bottom_space_left / 2 + bottom_space_left % 2

      [
        bg.(fg.(bottom_left)),
        bg.(title[:bottom_left].to_s),
        bg.(fg.(line_char(border.type) * bottom_space_before)),
        bg.(title[:bottom_center].to_s),
        bg.(fg.(line_char(border.type) * bottom_space_after)),
        bg.(title[:bottom_right].to_s),
        bg.(fg.(bottom_right))
      ].join('')
    end
  end # TTY
end # Box
