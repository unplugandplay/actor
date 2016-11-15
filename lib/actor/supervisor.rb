module Actor
  class Supervisor
    include Module::Dependencies
    include Module::Handler
    include Module::RunLoop

    include Messaging::Publish::Dependency

    attr_accessor :actor_count
    attr_writer :assembly_block
    attr_accessor :error
    attr_writer :thread_group

    def initialize
      @actor_count = 0
    end

    def self.build &assembly_block
      instance = new
      instance.assembly_block = assembly_block
      instance.configure
      instance
    end

    def self.start &assembly_block
      thread = Thread.new do
        thread_group = Thread.current.group

        prior_thread_count = thread_group.list.count

        instance = build &assembly_block

        thread_count = thread_group.list.count

        unless thread_count > prior_thread_count
          raise NoActorsStarted, "Assembly block must start at least one actor"
        end

        instance.run_loop
      end

      thread.join
    end

    def configure
      self.thread_group = Thread.current.group

      Address::Put.(address)

      assembly_block.(self)

      self.publish = Messaging::Publish.build
    end

    handle Messages::ActorStarted do |message|
      publish.register message.address

      self.actor_count += 1
    end

    handle Messages::ActorStopped do |message|
      publish.unregister message.address

      self.actor_count -= 1

      if actor_count.zero?
        Messages::Stop
      end
    end

    handle Messages::ActorCrashed do |message|
      self.error ||= message.error

      self.actor_count -= 1

      if actor_count.zero?
        Messages::Stop
      else
        Messages::Shutdown
      end
    end

    handle Messages::Shutdown do
      publish.(Messages::Stop)
    end

    handle Messages::Suspend do |message|
      publish.(message)
    end

    handle Messages::Resume do |message|
      publish.(message)
    end

    handle Messages::Stop do |stop|
      raise error if error

      super stop
    end

    def assembly_block
      @assembly_block ||= proc { }
    end

    def thread_group
      @thread_group ||= ThreadGroup::Default
    end

    NoActorsStarted = Class.new StandardError
  end
end
