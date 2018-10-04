# frozen_string_literal: true

module TTY
  module Box
    # A class reponsible for retrieving border options
    #
    # @api private
    class Border
      def self.parse(border)
        case border
        when Hash
          new(border)
        when *TTY::Box::BOX_CHARS.keys
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

      def initialize(type: :light,
        top: :line, top_left: true, top_right: true,
        left: :pipe, right: :pipe,
        bottom: :line, bottom_left: true, bottom_right: true)

        @type = type
        @top = top
        @top_left = top_left
        @top_right = top_right
        @left = left
        @right = right
        @bottom = bottom
        @bottom_left = bottom_left
        @bottom_right = bottom_right
      end
    end # Border
  end # Box
end # TTY

