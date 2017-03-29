require "ffi"

module Hello
  extend FFI::Library
  ffi_lib FFI::Library::LIBC
  attach_function :puts, [:string], :int
end

Hello.puts("Hello, world")
