require "fiddley"
require "test/unit"

class TestFiddleyEnum < Test::Unit::TestCase
  module EnumTest
    extend Fiddley::Library
    ffi_lib Fiddley::Library::LIBC

    enum :enum1
    enum :enum2, :a
    enum :enum3, [:b]
    enum :enum4, 123
    enum :enum5, :c, 456
    enum :enum6, [:d, 789]
    enum :enum7, [:e, 0x10, :f, :g, 0x100, :h]

    attach_function :puts, [:enum7], :int
  end

  test "enum_value" do
    assert_equal 0, EnumTest.enum_value(:enum1)
    assert_equal 0, EnumTest.enum_value(:enum2)
    assert_nil EnumTest.enum_value(:enum3)
    assert_equal 1, EnumTest.enum_value(:a)
    assert_equal 0, EnumTest.enum_value(:b)
    assert_equal 123, EnumTest.enum_value(:enum4)
    assert_equal 0, EnumTest.enum_value(:enum5)
    assert_equal 456, EnumTest.enum_value(:c)
    assert_nil EnumTest.enum_value(:enum6)
    assert_equal 789, EnumTest.enum_value(:d)
    assert_nil EnumTest.enum_value(:enum7)
    assert_equal 0x10, EnumTest.enum_value(:e)
    assert_equal 0x11, EnumTest.enum_value(:f)
    assert_equal 0x100, EnumTest.enum_value(:g)
    assert_equal 0x101, EnumTest.enum_value(:h)
  end

  test "enum_type" do
    assert_nil EnumTest.enum_type(:enum1)
    assert_nil EnumTest.enum_type(:enum2)
    assert_kind_of Fiddley::Enum, EnumTest.enum_type(:enum3)
    assert_nil EnumTest.enum_type(:enum4)
    assert_nil EnumTest.enum_type(:enum5)
    assert_kind_of Fiddley::Enum, EnumTest.enum_type(:enum6)
    assert_kind_of Fiddley::Enum, EnumTest.enum_type(:enum7)

    enum = EnumTest.enum_type(:enum3)
    assert_equal 1, enum.symbols.length
    assert_equal 0, enum[:b]
    assert_equal :b, enum[0]

    enum = EnumTest.enum_type(:enum6)
    assert_equal 1, enum.symbols.length
    assert_equal 789, enum[:d]
    assert_equal :d, enum[789]

    enum = EnumTest.enum_type(:enum7)
    assert_equal 4, enum.symbols.length
    assert_equal 0x10, enum[:e]
    assert_equal :e, enum[0x10]
    assert_equal 0x11, enum[:f]
    assert_equal :f, enum[0x11]
    assert_equal 0x100, enum[:g]
    assert_equal :g, enum[0x100]
    assert_equal 0x101, enum[:h]
    assert_equal :h, enum[0x101]
  end
end
