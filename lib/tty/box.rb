# frozen_string_literal: true

require "strings"
require "pastel"
require "tty-cursor"

require_relative "box/border"
require_relative "box/version"

module TTY
  # Responsible for drawing a box around content
  #
  # @api public
  class Box
    NEWLINE = "\n"
    SPACE = " "
    LINE_BREAK = /\r\n|\r|\n/.freeze

    # A frame for info type message
    #
    # @param [Array<String>] messages
    #   the message(s) to display
    #
    # @return [String]
    #
    # @api public
    def self.info(*messages, **opts, &block)
      new_opts = {
        title: {top_left: " ℹ INFO "},
        border: {type: :thick},
        padding: 1,
        style: {
          fg: :black,
          bg: :bright_blue,
          border: {
            fg: :black,
            bg: :bright_blue
          }
        }
      }.merge(opts)
      frame(*messages, **new_opts, &block)
    end

    # A frame for warning type message
    #
    # @param [Array<String>] messages
    #   the message(s) to display
    #
    # @return [String]
    #
    # @api public
    def self.warn(*messages, **opts, &block)
      new_opts = {
        title: {top_left: " ⚠ WARNING "},
        border: {type: :thick},
        padding: 1,
        style: {
          fg: :black,
          bg: :bright_yellow,
          border: {
            fg: :black,
            bg: :bright_yellow
          }
        }
      }.merge(opts)
      frame(*messages, **new_opts, &block)
    end

    # A frame for for success type message
    #
    # @param [Array<String>] messages
    #   the message(s) to display
    #
    # @return [String]
    #
    # @api public
    def self.success(*messages, **opts, &block)
      new_opts = {
        title: {top_left: " ✔ OK "},
        border: {type: :thick},
        padding: 1,
        style: {
          fg: :black,
          bg: :bright_green,
          border: {
            fg: :black,
            bg: :bright_green
          }
        }
      }.merge(opts)
      frame(*messages, **new_opts, &block)
    end

    # A frame for error type message
    #
    # @param [String] messages
    #   the message(s) to display
    #
    # @return [String]
    #
    # @api public
    def self.error(*messages, **opts, &block)
      new_opts = {
        title: {top_left: " ⨯ ERROR "},
        border: {type: :thick},
        padding: 1,
        style: {
          fg: :bright_white,
          bg: :red,
          border: {
            fg: :bright_white,
            bg: :red
          }
        }
      }.merge(opts)
      frame(*messages, **new_opts, &block)
    end

    # Render frame around content
    #
    # @example
    #   TTY::Box.frame { "Hello World" }
    #
    # @return [String]
    #   the rendered content inside a box
    #
    # @api public
    def self.frame(*content, **options, &block)
      new(*content, **options, &block).render
    end

    # The top position
    #
    # @return [Integer]
    #
    # @api public
    attr_reader :top

    # The left position
    #
    # @return [Integer]
    #
    # @api public
    attr_reader :left

    # The maximum width with border
    #
    # @return [Integer]
    #
    # @api public
    attr_reader :width

    # The maximum height with border
    #
    # @return [Integer]
    #
    # @api public
    attr_reader :height

    # The content colouring
    #
    # @return [Pastel]
    #
    # @api public
    attr_reader :color

    # The box title(s)
    #
    # @return [Hash{Symbol => String}]
    #
    # @api public
    attr_reader :title

    # The cursor movement
    #
    # @return [TTY::Cursor]
    #
    # @api public
    def cursor
      TTY::Cursor
    end

    # Create a Box instance
    #
    # @example
    #   box = TTY::Box.new("Hello World")
    #
    # @param [Integer] top
    #   the offset from the terminal top
    # @param [Integer] left
    #   the offset from the terminal left
    # @param [Integer] width
    #   the width of the box
    # @param [Integer] height
    #   the height of the box
    # @param [Symbol] align
    #   the content alignment
    # @param [Integer, Array<Integer>] padding
    #   the padding around content
    # @param [Hash] title
    #   the title for top or bottom border
    # @param [Hash, Symbol] border
    #   the border type out of ascii, light and thick
    # @param [Hash] style
    #   the styling for the content and border
    #
    # @api public
    def initialize(*content, top: nil, left: nil, width: nil, height: nil,
                   align: :left, padding: 0, title: {}, border: :light,
                   style: {}, enable_color: nil)
      @color = Pastel.new(enabled: enable_color)
      @style = style
      @top = top
      @left = left
      @title = title
      @align = align
      @padding = Strings::Padder.parse(padding)
      @border = Border.parse(border)
      # infer styling
      @fg, @bg = *extract_style(@style)
      @border_fg, @border_bg = *extract_style(@style[:border] || {})
      str = block_given? ? yield : content_to_str(content)
      @sep = str[LINE_BREAK] || NEWLINE # infer line break
      @content_lines = str.split(@sep)
      # infer dimensions
      total_width = @border.left_size + @padding.left +
                    original_content_width +
                    @border.right_size + @padding.right
      width ||= total_width
      @width = [width, top_space_taken, bottom_space_taken].max
      @formatted_lines = format_content(@content_lines, content_width)
      @height = height ||
                @border.top_size + @formatted_lines.size + @border.bottom_size
    end

    # The maximum content width without border and padding
    #
    # @return [Integer]
    #
    # @api public
    def content_width
      @width - @border.left_size - @padding.left -
        @padding.right - @border.right_size
    end

    # The maximum content height without border and padding
    #
    # @return [Integer]
    #
    # @api public
    def content_height
      @height - @border.top_size - @padding.top -
        @padding.bottom - @border.bottom_size
    end

    # Check whether this box is positioned or not
    #
    # @return [Boolean]
    #
    # @api public
    def position?
      !@top.nil? || !@left.nil?
    end

    # Check whether the content is styled or not
    #
    # @return [Boolean]
    #
    # @api public
    def content_style?
      !@style[:fg].nil? || !@style[:bg].nil?
    end

    # Render content inside a box
    #
    # @example
    #   box.render
    #
    # @return [String]
    #   the rendered box
    #
    # @api public
    def render
      output = []
      output << render_top_border if @border.top?

      (@height - @border.top_size - @border.bottom_size).times do |y|
        output << render_left_border(y)
        output << render_content_line(@formatted_lines[y])
        output << render_right_border(y) if @border.right?
        output << @sep unless position?
      end

      output << render_bottom_border if @border.bottom?
      output.join
    end

    private

    # Render top border
    #
    # @return [String]
    #
    # @api private
    def render_top_border
      position = cursor.move_to(@left, @top) if position?
      "#{position}#{top_border}#{@sep unless position?}"
    end

    # Render left border
    #
    # @param [Integer] offset
    #   the offset from the top border
    #
    # @return [String]
    #
    # @api private
    def render_left_border(offset)
      if position?
        position = cursor.move_to(@left, @top + offset + @border.top_size)
      end
      "#{position}#{color_border(@border.pipe_char) if @border.left?}"
    end

    # Render content line
    #
    # @param [String] formatted_line
    #   the formatted line
    #
    # @return [String]
    #
    # @api private
    def render_content_line(formatted_line)
      line = []
      filler_size = @width - @border.left_size - @border.right_size

      if formatted_line
        line << color_content(formatted_line)
        line_content_size = Strings::ANSI.sanitize(formatted_line)
                                         .scan(/[[:print:]]/).join.size
        filler_size = [filler_size - line_content_size, 0].max
      end

      if content_style? || !position?
        line << color_content(SPACE * filler_size)
      end

      line.join
    end

    # Render right border
    #
    # @param [Integer] offset
    #   the offset from the top border
    #
    # @return [String]
    #
    # @api private
    def render_right_border(offset)
      if position?
        position = cursor.move_to(@left + @width - @border.right_size,
                                  @top + offset + @border.top_size)
      end
      "#{position}#{color_border(@border.pipe_char)}"
    end

    # Render bottom border
    #
    # @return [String]
    #
    # @api private
    def render_bottom_border
      if position?
        position = cursor.move_to(@left, @top + @height - @border.bottom_size)
      end
      "#{position}#{bottom_border}#{@sep unless position?}"
    end

    # Convert content array to string
    #
    # @param [Array<String>] content
    #
    # @return [String]
    #
    # @api private
    def content_to_str(content)
      case content.size
      when 0 then ""
      when 1 then content[0]
      else content.join(NEWLINE)
      end
    end

    # The maximum original content width for all the lines
    #
    # @return [Integer]
    #
    # @api private
    def original_content_width
      return 1 if @content_lines.empty?

      @content_lines.map(&Strings::ANSI.method(:sanitize))
                    .max_by(&:length).length
    end

    # Convert style keywords into styling Proc objects
    #
    # @example
    #   extract_style({fg: :bright_yellow, bg: :blue})
    #
    # @param [Hash{Symbol => Symbol}] style
    #   the style configuration to extract from
    #
    # @return [Array<Proc>]]
    #
    # @api private
    def extract_style(style)
      [
        style[:fg] ? color.send(style[:fg]).detach : ->(c) { c },
        style[:bg] ? color.send(:"on_#{style[:bg]}").detach : ->(c) { c }
      ]
    end

    # Apply colour style to border
    #
    # @param [String] char
    #   the border character to colour
    #
    # @return [String]
    #
    # @api private
    def color_border(char)
      @border_bg.(@border_fg.(char))
    end

    # Apply colour style to content
    #
    # @param [String] content
    #   the content to colour
    #
    # @return [String]
    #
    # @api private
    def color_content(content)
      @bg.(@fg.(content))
    end

    # Format content by wrapping, aligning and padding out
    #
    # @param [Array<String>] lines
    #   the content lines to format
    # @param [Integer] width
    #   the maximum content width
    #
    # @return [Array[String]]
    #   the formatted content
    #
    # @api private
    def format_content(lines, width)
      return [] if lines.empty?

      formatted = lines.each_with_object([]) do |line, acc|
        wrapped = Strings::Wrap.wrap(line, width, separator: @sep)
        acc << Strings::Align.align(wrapped, width,
                                    direction: @align,
                                    separator: @sep)
      end.join(@sep)

      Strings::Pad.pad(formatted, @padding, separator: @sep).split(@sep)
    end

    # Top space taken by titles and corners
    #
    # @return [Integer]
    #
    # @api private
    def top_space_taken
      @border.top_left_corner.size +
        top_titles_size +
        @border.top_right_corner.size
    end

    # Top titles size
    #
    # @return [Integer]
    #
    # @api private
    def top_titles_size
      color.strip(title[:top_left].to_s).size +
        color.strip(title[:top_center].to_s).size +
        color.strip(title[:top_right].to_s).size
    end

    # Top border
    #
    # @return [String]
    #
    # @api private
    def top_border
      top_space_left = width - top_space_taken
      top_space_before = top_space_left / 2
      top_space_after  = top_space_left / 2 + top_space_left % 2

      [
        color_border(@border.top_left_corner),
        color_border(title[:top_left].to_s),
        color_border(@border.line_char * top_space_before),
        color_border(title[:top_center].to_s),
        color_border(@border.line_char * top_space_after),
        color_border(title[:top_right].to_s),
        color_border(@border.top_right_corner)
      ].join
    end

    # Bottom space taken by titles and corners
    #
    # @return [Integer]
    #
    # @api private
    def bottom_space_taken
      @border.bottom_left_corner.size +
        bottom_titles_size +
        @border.bottom_right_corner.size
    end

    # Bottom titles size
    #
    # @return [Integer]
    #
    # @api private
    def bottom_titles_size
      color.strip(title[:bottom_left].to_s).size +
        color.strip(title[:bottom_center].to_s).size +
        color.strip(title[:bottom_right].to_s).size
    end

    # Bottom border
    #
    # @return [String]
    #
    # @api private
    def bottom_border
      bottom_space_left = width - bottom_space_taken
      bottom_space_before = bottom_space_left / 2
      bottom_space_after = bottom_space_left / 2 + bottom_space_left % 2

      [
        color_border(@border.bottom_left_corner),
        color_border(title[:bottom_left].to_s),
        color_border(@border.line_char * bottom_space_before),
        color_border(title[:bottom_center].to_s),
        color_border(@border.line_char * bottom_space_after),
        color_border(title[:bottom_right].to_s),
        color_border(@border.bottom_right_corner)
      ].join
    end
  end # Box
end # TTY
