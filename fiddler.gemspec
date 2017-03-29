lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fiddler"

Gem::Specification.new do |spec|
  spec.name          = "fiddler"
  spec.version       = Fiddler::VERSION
  spec.authors       = ["U.Nakamura"]
  spec.email         = ["usa@garbagecollect.jp"]

  spec.summary       = "FFI compatible interface for Fiddle"
  spec.description   = "Use Fiddle instead of Ruby-FFI !!!"
  spec.homepage      = "https://github.com/unak/fiddler"
  spec.license       = "BSD-2-Clause"

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^tmp/|^tools/|^examples/|^\.}) }
  spec.bindir        = "bin"
  spec.executables   = []
  spec.require_paths = ["lib"]
end
