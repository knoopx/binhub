module BinHub
  class BlockQueue < ::Queue
    def push(obj = nil, &block)
      if block_given?
        super(block)
      else
        super(obj)
      end
    end
  end
end