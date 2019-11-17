require "fiddle/import"
require "fiddley/utils"

module Fiddley
  class MemoryPointer
    if defined?(Fiddley::RefineStringUnpack1)
      using Fiddley::RefineStringUnpack1
    end

    include Fiddley::Utils

    def initialize(type, num = 1, clear = true)
      if num.is_a?(Fiddle::Pointer)
        @ptr = num
        @size = @ptr.size
      else
        @size = type2size(type) * num
        @ptr = Fiddle::Pointer.malloc(@size)
      end
    end

    attr_reader :size

    def to_ptr
      @ptr
    end

    {8 => 'c', 16 => 's', 32 => 'l', 64 => 'q'}.each_pair do |bits, form|
      bytes = bits/8

      define_method("put_int#{bits}") do |offset, val|
        @ptr[offset, bytes] = [val].pack(form)
      end

      define_method("write_int#{bits}") do |val|
        __send__("put_int#{bits}", 0, val)
      end

      define_method("put_array_of_int#{bits}") do |offset, ary|
        put_bytes(offset, ary.pack(form + '*'))
      end

      define_method("write_array_of_int#{bits}") do |ary|
        __send__("put_array_of_int#{bits}", 0, ary)
      end

      define_method("get_int#{bits}") do |offset|
        @ptr[offset, bytes].unpack1(form)
      end

      define_method("read_int#{bits}") do
        __send__("get_int#{bits}", 0)
      end

      define_method("get_array_of_int#{bits}") do |offset, num|
        @ptr[offset, bytes*num].unpack(form + '*')
      end

      define_method("read_array_of_int#{bits}") do |num|
        __send__("get_array_of_int#{bits}", 0, num)
      end

      form2 = form.upcase

      define_method("put_uint#{bits}") do |offset, val|
        @ptr[offset, bytes] = [val].pack(form2)
      end

      define_method("write_uint#{bits}") do |val|
        __send__("put_uint#{bits}", 0, val)
      end

      define_method("put_array_of_uint#{bits}") do |offset, ary|
        put_bytes(offset, ary.pack(form2 + '*'))
      end

      define_method("write_array_of_uint#{bits}") do |ary|
        __send__("put_array_of_uint#{bits}", 0, ary)
      end

      define_method("get_uint#{bits}") do |offset|
        @ptr[offset, bytes].unpack1(form2)
      end

      define_method("read_uint#{bits}") do
        __send__("get_uint#{bits}", 0)
      end

      define_method("get_array_of_uint#{bits}") do |offset, num|
        @ptr[offset, bytes*num].unpack(form2 + '*')
      end

      define_method("read_array_of_uint#{bits}") do |num|
        __send__("get_array_of_uint#{bits}", 0, num)
      end
    end

    def put_bytes(offset, str, idx = 0, len = str.bytesize - idx)
      @ptr[offset, len] = str[idx, len]
    end

    def write_bytes(str, idx = 0, len = nil)
      put_bytes(0, str, idx, len)
    end

    def get_bytes(offset, len)
      @ptr[offset, len]
    end

    def read_bytes(len)
      get_bytes(0, len)
    end

    def put_string(offset, str)
      @ptr[offset, str.bytesize] = str
    end

    def write_string(str, len = nil)
      put_string(0, len ? str[0, len] : str)
    end

    def write_string_length(str, len)
      put_string(0, str[0, len])
    end

    def get_string(offset, len = nil)
      @ptr[offset, len ? len : @size - offset]
    end

    def read_string(len = nil)
      get_string(0, len)
    end

    alias put_int put_int32
    alias write_int write_int32
    alias get_int get_int32
    alias read_int read_int32

    alias put_uint put_uint32
    alias write_uint write_uint32
    alias get_uint get_uint32
    alias read_uint read_uint32
  end
end
