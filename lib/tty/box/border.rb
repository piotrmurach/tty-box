module TTY
  module Box
    # A class reponsible for retrieving border options
    #
    # @api private
    class Border
      def self.parse(border)
        case border
        when Hash
          new(border[:type],
              border.fetch(:top, true),
              border.fetch(:left, true),
              border.fetch(:right, true),
              border.fetch(:bottom, true))
        when *TTY::Box::BOX_CHARS.keys
          new(border, true, true, true, true)
        else
          raise ArgumentError,
                "Wrong value `#{border}` for :border configuration option"
        end
      end

      attr_reader :type, :top, :left, :right, :bottom

      alias top? top
      alias left? left
      alias right? right
      alias bottom? bottom

      def initialize(type, top, left, right, bottom)
        @type = type
        @top = top
        @left = left
        @right = right
        @bottom = bottom
      end
    end # Border
  end # Box
end # TTY

