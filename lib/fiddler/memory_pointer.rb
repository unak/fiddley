require "fiddle/import"

module Fiddler
  class MemoryPointer
    def initialize(type, num = 1)
      size = Fiddler.type2size(type) * num
      @ptr = Fiddle::Pointer.malloc(size)
    end

    def write_int16(val)
      @ptr[0, 2] = [val].pack('s')
    end

    def write_int32(val)
      @ptr[0, 4] = [val].pack('l')
    end

    def write_array_of_uint32(ary)
      write_string(ary.pack('L*'))
    end

    def write_string(str)
      @ptr[0, str.bytesize] = str
    end

    def read_bytes(size)
      @ptr[0, size]
    end

    def read_int8
      get_int8(0)
    end

    def read_uint8
      get_uint8(0)
    end

    def read_int16
      get_int16(0)
    end

    def read_uint16
      get_uint16(0)
    end

    def read_int32
      get_int32(0)
    end

    def read_uint32
      get_uint32(0)
    end

    def get_int8(offset)
      @ptr[offset, 1].unpack1('c')
    end

    def get_uint8(offset)
      @ptr[offset, 1].unpack1('C')
    end

    def get_int16(offset)
      @ptr[offset, 2].unpack1('s')
    end

    def get_uint16(offset)
      @ptr[offset, 2].unpack1('S')
    end

    def get_int32(offset)
      @ptr[offset, 4].unpack1('l')
    end

    def get_uint32(offset)
      @ptr[offset, 4].unpack1('L')
    end

    alias read_int read_int32
    alias get_int get_int32

    def to_ptr
      @ptr
    end
  end
end
