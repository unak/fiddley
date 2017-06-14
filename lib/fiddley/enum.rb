module Fiddley
  class Enum
    def initialize(*args)
      info, @tag = *args
      @map = {}
      if info
        last = nil
        value = 0
        info.each do |k|
          if k.is_a?(Symbol)
            @map[k] = value
            last = k
            value += 1
          elsif k.is_a?(Integer)
            @map[last] = k
            value = k + 1
          else
            raise RuntimeError, "broken enum"
          end
        end
      end
      @rmap = @map.invert
    end

    attr_reader :tag

    def symbols
      @map.keys
    end

    def [](k)
      if k.is_a?(Symbol)
        @map[k]
      elsif k.is_a?(Integer)
        @rmap[k]
      end
    end
    alias find []

    def symbol_map
      @map
    end
    alias to_h symbol_map
    alias to_hash symbol_map
  end
end
