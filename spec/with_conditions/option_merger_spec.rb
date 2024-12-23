# frozen_string_literal: true

RSpec.describe WithConditions::OptionMerger do
  describe "#inspect" do
    it "is reasonable" do
       option_merger = described_class.new(:context, if: :foo?, unless: :bar?)
       expect(option_merger.inspect).to include(
         "#<WithConditions::OptionMerger:",
         "if_conds=[:foo?]",
         "unless_conds=[:bar?]",
         "context=:context",
       )
    end
  end
end
