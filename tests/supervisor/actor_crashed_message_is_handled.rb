require_relative '../test_init'

context "Actor crashed message is handled by supervisor" do
  error = Controls::Error.example
  actor_crashed = Supervisor::ActorCrashed.new error

  supervisor = Supervisor.new
  return_value = supervisor.handle actor_crashed

  test "Error is set on supervisor" do
    assert supervisor.error == error
  end

  test "Stop message is returned" do
    assert return_value.instance_of? Messages::Stop
  end
end