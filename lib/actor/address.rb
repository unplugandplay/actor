module Actor
  Address = Struct.new :stream, :uuid do
    def self.build stream=nil
      stream ||= Stream.new

      uuid = SecureRandom.uuid

      instance = new stream, uuid
      instance
    end
  end

  class Address
    NoneClass = Class.new Address

    None = NoneClass.new Stream::Null, 'no-stream'
  end
end
