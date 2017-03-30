require "fiddle/import"

module Fiddley
  class Struct
    def self.layout(*args)
      @members = {}
      @size = 0
      args.each_slice(2) do |name, type|
        @members[name] = [type, @size]
        @size += Fiddley.type2size(type)
      end
    end

    def self.ptr
      :pointer
    end

    def self.members
      @members
    end

    def self.size
      @size
    end

    def self.offset_of(key)
      raise IndexError, "#{key} is not defined" unless members.has_key?(key)
      type, offset = members[key]
      offset
    end

    def initialize
      @ptr = Fiddle::Pointer.malloc(self.class.size)
    end

    def [](key)
      raise IndexError, "#{key} is not defined" unless self.class.members.has_key?(key)
      type, offset = self.class.members[key]
      Fiddley.str2value(type, @ptr[offset, Fiddley.type2size(type)])
    end

    def []=(key, value)
      raise IndexError, "#{key} is not defined" unless self.class.members.has_key?(key)
      type, offset = self.class.members[key]
      @ptr[offset, Fiddley.type2size(type)] = Fiddley.value2str(type, value)
    end

    def to_ptr
      @ptr
    end
  end
end
