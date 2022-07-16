# frozen_string_literal: true

module TTY
  class Box
    # A class reponsible for retrieving border options
    #
    # @api private
    class Border
      BOX_CHARS = {
        ascii: %w[+ + + + + + + + - | +],
        light: %w[┘ ┐ ┌ └ ┤ ┴ ┬ ├ ─ │ ┼],
        thick: %w[╝ ╗ ╔ ╚ ╣ ╩ ╦ ╠ ═ ║ ╬],
        round: %w[╯ ╮ ╭ ╰ ┤ ┴ ┬ ├ ─ │ ┼]
      }.freeze

      BORDER_VALUES = %i[
        corner_bottom_right
        corner_top_right
        corner_top_left
        corner_bottom_left
        divider_left
        divider_up
        divider_down
        divider_right
        line
        pipe
        cross
      ].freeze

      # Parse border configuration
      #
      # @api public
      def self.parse(border)
        case border
        when Hash
          new(**border)
        when *BOX_CHARS.keys
          new(type: border)
        else
          raise ArgumentError,
                "Wrong value `#{border}` for :border configuration option"
        end
      end

      attr_reader :type, :top, :top_left, :top_right, :left, :right,
                  :bottom, :bottom_left, :bottom_right

      alias top? top
      alias left? left
      alias right? right
      alias bottom? bottom
      alias top_left? top_left
      alias top_right? top_right
      alias bottom_left? bottom_left
      alias bottom_right? bottom_right

      def initialize(type: :light,
                     top: :line,
                     top_left: :corner_top_left,
                     top_right: :corner_top_right,
                     left: :pipe,
                     right: :pipe,
                     bottom: :line,
                     bottom_left: :corner_bottom_left,
                     bottom_right: :corner_bottom_right)

        @type         = type
        @top          = check_name(:top, top)
        @top_left     = check_name(:top_left, top_left)
        @top_right    = check_name(:top_right, top_right)
        @left         = check_name(:left, left)
        @right        = check_name(:right, right)
        @bottom       = check_name(:bottom, bottom)
        @bottom_left  = check_name(:bottom_left, bottom_left)
        @bottom_right = check_name(:bottom_right, bottom_right)
      end

      # Top border size
      #
      # @return [Integer]
      #
      # @api public
      def top_size
        top? ? 1 : 0
      end

      # Left border size
      #
      # @return [Integer]
      #
      # @api public
      def left_size
        left? ? 1 : 0
      end

      # Right border size
      #
      # @return [Integer]
      #
      # @api public
      def right_size
        right? ? 1 : 0
      end

      # Bottom border size
      #
      # @return [Integer]
      #
      # @api public
      def bottom_size
        bottom? ? 1 : 0
      end

      # Top left corner
      #
      # @return [String]
      #
      # @api public
      def top_left_corner
        return "" unless top_left? && left?

        send(:"#{top_left}_char")
      end

      # Top right corner
      #
      # @return [String]
      #
      # @api public
      def top_right_corner
        return "" unless top_right? && right?

        send(:"#{top_right}_char")
      end

      # Bottom left corner
      #
      # @return [String]
      #
      # @api public
      def bottom_left_corner
        return "" unless bottom_left? && left?

        send(:"#{bottom_left}_char")
      end

      # Bottom right corner
      #
      # @return [String]
      #
      # @api public
      def bottom_right_corner
        return "" unless bottom_right? && right?

        send(:"#{bottom_right}_char")
      end

      # Bottom right corner character
      #
      # @api public
      def corner_bottom_right_char
        BOX_CHARS[type][0]
      end

      # Top right corner character
      #
      # @api public
      def corner_top_right_char
        BOX_CHARS[type][1]
      end

      # Top left corner character
      #
      # @api public
      def corner_top_left_char
        BOX_CHARS[type][2]
      end

      # Bottom left corner character
      #
      # @api public
      def corner_bottom_left_char
        BOX_CHARS[type][3]
      end

      # Left divider character
      #
      # @api public
      def divider_left_char
        BOX_CHARS[type][4]
      end

      # Up divider character
      #
      # @api public
      def divider_up_char
        BOX_CHARS[type][5]
      end

      # Down divider character
      #
      # @api public
      def divider_down_char
        BOX_CHARS[type][6]
      end

      # Right divider character
      #
      # @api public
      def divider_right_char
        BOX_CHARS[type][7]
      end

      # Horizontal line character
      #
      # @api public
      def line_char
        BOX_CHARS[type][8]
      end

      # Vertical line character
      #
      # @api public
      def pipe_char
        BOX_CHARS[type][9]
      end

      # Intersection character
      #
      # @api public
      def cross_char
        BOX_CHARS[type][10]
      end

      private

      # Check if border values name is allowed
      #
      # @raise [ArgumentError]
      #
      # @api private
      def check_name(key, value)
        unless BORDER_VALUES.include?(:"#{value}") ||
               [true, false].include?(value)
          raise ArgumentError, "invalid #{key.inspect} border value: " \
                              "#{value.inspect}"
        end

        value
      end
    end # Border
  end # Box
end # TTY
