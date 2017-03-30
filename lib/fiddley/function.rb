require "fiddle/import"
require "fiddley/utils"

module Fiddley
  class Function
    def initialize(ret, params, blk)
      Module.new do
        extend Fiddle::Importer
        dlload Fiddley::Library::LIBC
        @@func = bind("#{Fiddley::Utils.type2str(ret)} callback(#{params.map{|e| Fiddley::Utils.type2str(e)}.join(', ')})", &blk)
      end
    end
  end
end
