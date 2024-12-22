# frozen_string_literal: true

module WithConditions
  class OptionMerger < BasicObject
    def initialize(context, if:, unless:)
      @context = context
      @if_conds = Array(::Kernel.binding.local_variable_get(:if))
      @unless_conds = Array(::Kernel.binding.local_variable_get(:unless))
    end

    private

    def method_missing(method, *, **kwargs, &)
      kwargs[:if] = @if_conds + Array(kwargs[:if])
      kwargs[:unless] = @unless_conds + Array(kwargs[:unless])
      @context.__send__(method, *, **kwargs, &)
    end

    def respond_to_missing?(...) = @context.respond_to?(...)
    def Array(...) = ::Kernel.Array(...)
  end
end
