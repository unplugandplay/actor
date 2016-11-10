module Actor
  def self.included cls
    # Actor can be included in the main object (TOPLEVEL_BINDING.receiver) in
    # order to bring the constants contained in within the Actor namespace to
    # the top level. When we do so, it is necessary to prevent the actual mixin
    # from altering the main object.
    return if cls == TOPLEVEL_BINDING.receiver

    cls.class_exec do
      include Module::Dependencies
      include Module::Handler
      include Module::RunLoop
      include Module::SuspendResume
    end
  end
end
