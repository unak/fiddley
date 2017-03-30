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

  def self.type2size(type)
    case type
    when :char, :uchar, :int8, :uint8
      1
    when :short, :ushort, :int16, :uint16
      2
    when :int, :uint, :int32, :uint32
      4
    when :long, :ulong, :int64, :uint64
      8
    when :string, :pointer
      8
    else
      raise TypeError, "unknown type #{type}"
    end
  end

  def self.str2value(type, str)
    case type
    when :char, :uchar, :int8, :uint8
      str.unpack1('c')
    when :short, :ushort, :int16, :uint16
      str.unpack1('s')
    when :int, :uint, :int32, :uint32
      str.unpack1('l')
    when :long, :ulong, :int64, :uint64
      str.unpack1('Q')
    when :string, :pointer
      str.unpack1('p')
    else
      raise TypeError, "unknown type #{type}"
    end
  end

  def self.value2str(type, value)
    case type
    when :char, :uchar, :int8, :uint8
      [value].pack('c')
    when :short, :ushort, :int16, :uint16
      [value].pack('s')
    when :int, :uint, :int32, :uint32
      [value].pack('l')
    when :long, :ulong, :int64, :uint64
      [value].pack('Q')
    when :string, :pointer
      [value].pack('p')
    else
      raise TypeError, "unknown type #{type}"
    end
  end

  def self.type2str(type)
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
    when :long, :int64
      "long"
    when :ulong, :uint64
      "unsigned long"
    when :long_long
      "long long"
    when :ulong_long
      "unsigned long long"
    when :string, :pointer
      "void *"
    else
      type.to_s
    end
  end
end
