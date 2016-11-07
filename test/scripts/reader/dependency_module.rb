require_relative '../scripts_init'

context "Reader, Dependency Module" do
  context "Class includes dependency module" do
    cls = Class.new do
      include Messaging::Reader::Dependency
    end

    context "Object is instantiated" do
      object = cls.new

      test "Reader attribute getter returns substitute" do
        assert object.reader do
          instance_of? Messaging::Reader::Substitute
        end
      end

      context "Reader attribute is specified" do
        address = Messaging::Address.build
        reader = Messaging::Reader.build address

        object.reader = reader

        test "Reader attribute is set to specified reader" do
          assert object.reader == reader
        end
      end
    end
  end
end