require_relative '../scripts_init'

context "Writer, Writes Message to a Full Queue" do
  address = Messaging::Address.build max_queue_size: 1

  writer = Messaging::Writer.new
  writer.write :insignificant_message, address

  context "Wait is not specified" do
    blocked = false

    read_thread = Thread.new do
      Thread.pass until address.queue.num_waiting > 0
      blocked = true
      address.queue.deq
    end

    test "Thread is blocked until another thread writes to queue" do
      writer.write :some_message, address

      assert blocked
    end

    read_thread.join
  end

  context "Wait is disabled" do
    test "WouldBlockError is raised" do
      assert proc { writer.write :some_message, address, wait: false } do
        raises_error? Messaging::Writer::WouldBlockError
      end
    end
  end
end