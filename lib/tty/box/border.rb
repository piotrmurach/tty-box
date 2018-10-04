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

      attr_reader :type, :top, :left, :right, :bottom

      alias top? top
      alias left? left
      alias right? right
      alias bottom? bottom

      def initialize(type: :light, top: true, left: true, right: true, bottom: true)
        @type = type
        @top = top
        @left = left
        @right = right
        @bottom = bottom
      end
    end # Border
  end # Box
end # TTY

