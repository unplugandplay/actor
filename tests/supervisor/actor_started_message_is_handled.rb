require_relative '../test_init'

context "Actor started message is handled by a supervisor" do
  actor_started = Controls::Message::ActorStarted.example

  actor_address = actor_started.actor_address
  supervisor_address = Controls::Address::Supervisor.example
  router_address = Controls::Address::Router.example

  supervisor = Supervisor.new
  supervisor.address = supervisor_address
  supervisor.router_address = router_address

  supervisor.handle actor_started

  test "Route is added from supervisor broadcast address to actor address" do
    assert supervisor.writer do
      written? do |msg, addr|
        next unless msg.is_a? Router::AddRoute

        msg.reader.stream == supervisor_address.stream and
          msg.output_address == actor_address and
          addr == router_address
      end
    end
  end
end
