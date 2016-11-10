require_relative '../../test_init'

context "Actor Handles a Message, Handler Returns New Message" do
  address = Messaging::Address.build
  message = Fixtures::Controls::Message.example

  actor = Fixtures::Controls::Actor.define_singleton do
    handle message do |msg|
      msg
    end
  end

  actor.address = address

  actor.handle message

  test "Message is written to address of actor" do
    assert actor.writer do
      written? message, address: address
    end
  end
end