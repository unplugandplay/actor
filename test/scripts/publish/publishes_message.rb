require_relative '../../test_init'

context "Publisher, Publishes Message" do
  address = Controls::Address.example

  context "Multiple addresses are registered" do
    other_address = Controls::Address::Other.example

    publish = Messaging::Publish.new
    publish.register address
    publish.register other_address
    publish.(:some_message)

    test "Message is sent to each registered address" do
      assert publish.send do
        sent? :some_message, address: address
      end

      assert publish.send do
        sent? :some_message, address: other_address
      end
    end
  end

  [["Wait is not specified", nil], ["Wait is disabled", false]].each do |prose, wait|
    context prose do
      publish = Messaging::Publish.new
      publish.register address
      publish.(:some_message, wait: wait)

      test "Send operation is not permitted to block" do
        assert publish.send do
          sent? wait: false
        end
      end
    end
  end

  context "Wait is enabled" do
    publish = Messaging::Publish.new
    publish.register address
    publish.(:some_message, wait: true)

    test "Send operation is permitted to block" do
      assert publish.send do
        sent? wait: true
      end
    end
  end
end
