module Fiddley
  unless "".respond_to?(:unpack1)
    module RefineStringUnpack1
      refine String do
        def unpack1(arg)
          unpack(arg).first
        end
      end
    end

    using RefineStringUnpack1
  end

  module Utils
    # assumes short = 16bit, int = 32bit, long long = 64bit
    LONG_SIZE = [0].pack('l!').bytesize
    POINTER_SIZE = [nil].pack('p').bytesize
    SIZET_FORMAT = POINTER_SIZE == LONG_SIZE ? 'l!' : 'q'
    SIZET_TYPE = POINTER_SIZE == LONG_SIZE ? 'unsigned long' : 'unsigned long long'

    module_function def type2size(type)
      case type
      when :char, :uchar, :int8, :uint8
        1
      when :short, :ushort, :int16, :uint16
        2
      when :int, :uint, :int32, :uint32, :bool
        4
      when :long, :ulong
        LONG_SIZE
      when :int64, :uint64, :long_long, :ulong_long
        8
      when :string, :pointer, :size_t
        POINTER_SIZE
      else
        raise ArgumentError, "unknown type #{type}"
      end
    end

    module_function def str2value(type, str)
      case type
      when :char, :int8
        str.unpack1('c')
      when :uchar, :uint8
        str.unpack1('C')
      when :short, :int16
        str.unpack1('s')
      when :ushort, :uint16
        str.unpack1('S')
      when :int32
        str.unpack1('l')
      when :uint32
        str.unpack1('L')
      when :int
        str.unpack1('i!')
      when :uint
        str.unpack1('I!')
      when :bool
        str.unpack1('i!') != 0
      when :long
        str.unpack1('l!')
      when :ulong
        str.unpack1('L!')
      when :long_long, :int64
        str.unpack1('q')
      when :ulong_long, :uint64
        str.unpack1('Q')
      when :string, :pointer
        str.unpack1('p')
      when :size_t
        str.unpack1(SIZET_FORMAT)
      else
        raise ArgumentError, "unknown type #{type}"
      end
    end

    module_function def value2str(type, value)
      case type
      when :char, :int8
        [value].pack('c')
      when :uchar, :uint8
        [value].pack('C')
      when :short, :int16
        [value].pack('s')
      when :ushort, :uint16
        [value].pack('S')
      when :int32
        [value].pack('l')
      when :uint32
        [value].pack('L')
      when :int
        [value].pack('i!')
      when :uint
        [value].pack('I!')
      when :bool
        [value ? 1 : 0].pack('i!')
      when :long
        [value].pack('l!')
      when :ulong
        [value].pack('L!')
      when :long_long, :int64
        [value].pack('q')
      when :ulong_long, :uint64
        [value].pack('Q')
      when :string, :pointer
        [value].pack('p')
      when :size_t
        [value].pack(SIZET_FORMAT)
      else
        raise ArgumentError, "unknown type #{type}"
      end
    end

    module_function def type2str(type)
      case type
      when :char, :int8
        "char"
      when :uchar, :uint8
        "unsigned char"
      when :short, :int16
        "short"
      when :ushort, :uint16
        "unsigned short"
      when :int, :int32
        "int"
      when :uint, :uint32
        "unsigned int"
      when :long
        "long"
      when :ulong
        "unsigned long"
      when :long_long, :int64
        "long long"
      when :ulong_long, :uint64
        "unsigned long long"
      when :string, :pointer
        "void *"
      when :size_t
        SIZET_TYPE
      else
        type.to_s
      end
    end
  end
end
