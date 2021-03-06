require_relative '../../test_init'

context "Run Loop Iterates when Queue is Empty" do
  actor = Controls::Actor::Example.new

  test "Actor waits for reader to receive incoming message" do
    assert proc { actor.run_loop } do
      raises_error? Messaging::Queue::Substitute::WouldBlockError
    end
  end
end
