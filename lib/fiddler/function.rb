require "fiddle/import"

module Fiddler
  class Function
    def initialize(ret, params, blk)
      Module.new do
        extend Fiddle::Importer
        dlload Fiddler::Library::LIBC
        @@func = bind("#{Fiddler.type2str(ret)} callback(#{params.map{|e|Fiddler.type2str(e)}.join(', ')})", &blk)
      end
    end
  end
end
