# frozen_string_literal: true

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

# To keep things simple, we include this in all objects, like `with_options`.
#
# Otherwise we would want specs that include Active Record, and we'd want to consider that different versions of Rails use Active Model in different ways (e.g. only recent Rails per 2024-12-22 include ActiveModel::API in ActiveRecord::Base`).
Object.extend WithConditions
