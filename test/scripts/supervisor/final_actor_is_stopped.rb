require_relative '../../test_init'

context "Supervisor Handles Final Actor Stopped Message" do
  actor_stopped, actor = Fixtures::Controls::Message::ActorStopped.pair
  supervisor = Supervisor.new

  supervisor.actor_count = 1

  supervisor.handle actor_stopped

  test "Supervisor sends itself the shutdown message" do
    assert supervisor.writer do
      written? Messages::Shutdown, address: supervisor.address
    end
  end
end