require "fiddle"
require "fiddley/utils"

module Fiddley
  class Function < Fiddle::Closure::BlockCaller
    include Fiddley::Utils

    def initialize(ret, params, &blk)
      super(type2type(ret), params.map{|e| type2type(e)}, &blk)
    end
  end
end
