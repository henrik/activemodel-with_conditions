# frozen_string_literal: true

require "active_model"
require_relative "with_conditions/options_merger"
require_relative "with_conditions/version"

module WithConditions
  def with_conditions(if: nil, unless: nil, &block)
    option_merger = WithConditions::OptionMerger.new(self, if:, unless:)

    if block
      block.arity.zero? ? option_merger.instance_eval(&block) : block.call(option_merger)
    else
      option_merger
    end
  end
end

module ActiveModel
  module API
    singleton_class.prepend(Module.new do
      def included(klass)
        super
        klass.extend WithConditions
      end
    end)
  end
end
