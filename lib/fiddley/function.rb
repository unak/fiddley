require "fiddle/import"

module Fiddley
  class Function
    def initialize(ret, params, blk)
      Module.new do
        extend Fiddle::Importer
        dlload Fiddley::Library::LIBC
        @@func = bind("#{Fiddley.type2str(ret)} callback(#{params.map{|e|Fiddley.type2str(e)}.join(', ')})", &blk)
      end
    end
  end
end
