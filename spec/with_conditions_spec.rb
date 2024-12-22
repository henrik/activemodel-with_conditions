# frozen_string_literal: true

require "active_model"
require "active_support/core_ext/object/with_options"

RSpec.describe WithConditions do
  let(:model_class) do
    Class.new {
      include ActiveModel::Model
      attr_accessor :value, :cond_1, :cond_2, :cond_3, :cond_4
    }
  end

  describe ":if conditions" do
    it "can add an :if condition as a symbol" do
      model_class.class_eval do
        with_conditions if: :cond_1 do
          validates :value, presence: true
        end
      end

      expect(model_class.new(cond_1: true)).not_to be_valid
      expect(model_class.new(cond_1: false)).to be_valid
    end

    it "can add an :if condition as a lambda without a block argument" do
      model_class.class_eval do
        with_conditions if: -> { cond_1 } do
          validates :value, presence: true
        end
      end

      expect(model_class.new(cond_1: true)).not_to be_valid
      expect(model_class.new(cond_1: false)).to be_valid
    end

    it "can add an :if condition as a lambda with a block argument" do
      model_class.class_eval do
        with_conditions if: ->(x) { x.cond_1 } do
          validates :value, presence: true
        end
      end

      expect(model_class.new(cond_1: true)).not_to be_valid
      expect(model_class.new(cond_1: false)).to be_valid
    end

    it "can add :if conditions as an array" do
      model_class.class_eval do
        with_conditions if: [ :cond_1, -> { cond_2 } ] do
          validates :value, presence: true
        end
      end

      expect(model_class.new(cond_1: true, cond_2: true)).not_to be_valid
      expect(model_class.new(cond_1: false, cond_2: true)).to be_valid
      expect(model_class.new(cond_1: true, cond_2: false)).to be_valid
    end

    it "merges single :if conditions" do
      model_class.class_eval do
        with_conditions if: :cond_1 do
          validates :value, presence: true, if: :cond_2
        end
      end

      expect(model_class.new(cond_1: true, cond_2: true)).not_to be_valid
      expect(model_class.new(cond_1: false, cond_2: true)).to be_valid
      expect(model_class.new(cond_1: true, cond_2: false)).to be_valid
    end

    it "merges array :if conditions" do
      model_class.class_eval do
        with_conditions if: [ :cond_1, :cond_2 ] do
          validates :value, presence: true, if: [ :cond_3, :cond_4 ]
        end
      end

      expect(model_class.new(cond_1: true, cond_2: true, cond_3: true, cond_4: true)).not_to be_valid
      expect(model_class.new(cond_1: true, cond_2: false, cond_3: true, cond_4: true)).to be_valid
      expect(model_class.new(cond_1: true, cond_2: true, cond_3: true, cond_4: false)).to be_valid
    end
  end

  it "also works for :unless (requiring all conditions to be false)" do
    model_class.class_eval do
      with_conditions unless: [ :cond_1, :cond_2 ] do
        validates :value, presence: true, unless: [ :cond_3, :cond_4 ]
      end
    end

    expect(model_class.new(cond_1: false, cond_2: false, cond_3: false, cond_4: false)).not_to be_valid
    expect(model_class.new(cond_1: false, cond_2: true, cond_3: false, cond_4: false)).to be_valid
    expect(model_class.new(cond_1: false, cond_2: false, cond_3: false, cond_4: true)).to be_valid
  end

  it "lets you combine :if and :unless" do
    model_class.class_eval do
      with_conditions if: :cond_1, unless: :cond_2 do
        validates :value, presence: true, if: :cond_3, unless: :cond_4
      end
    end

    expect(model_class.new(cond_1: true, cond_2: false, cond_3: true, cond_4: false)).not_to be_valid
    expect(model_class.new(cond_1: false, cond_2: false, cond_3: true, cond_4: false)).to be_valid
    expect(model_class.new(cond_1: true, cond_2: true, cond_3: true, cond_4: false)).to be_valid
    expect(model_class.new(cond_1: true, cond_2: false, cond_3: false, cond_4: false)).to be_valid
    expect(model_class.new(cond_1: true, cond_2: false, cond_3: true, cond_4: true)).to be_valid
  end

  it "can be nested" do
    model_class.class_eval do
      with_conditions if: :cond_1 do
        with_conditions if: :cond_2 do
          validates :value, presence: true, if: :cond_3
        end
      end
    end

    expect(model_class.new(cond_1: true, cond_2: true, cond_3: true)).not_to be_valid
    expect(model_class.new(cond_1: false, cond_2: true, cond_3: true)).to be_valid
    expect(model_class.new(cond_1: true, cond_2: false, cond_3: true)).to be_valid
    expect(model_class.new(cond_1: true, cond_2: true, cond_3: false)).to be_valid
  end

  describe "other ways of using" do
    it "can be used with an explicit block argument" do
      model_class.class_eval do
        with_conditions if: :cond_1 do |conds|
          conds.validates :value, presence: true
        end
      end

      expect(model_class.new(cond_1: true)).not_to be_valid
      expect(model_class.new(cond_1: false)).to be_valid
    end

    it "can be assigned to a variable" do
      model_class.class_eval do
        conds = with_conditions(if: :cond_1)
        conds.validates :value, presence: true
      end

      expect(model_class.new(cond_1: true)).not_to be_valid
      expect(model_class.new(cond_1: false)).to be_valid
    end
  end

  describe "combining with with_options" do
    it "works" do
      model_class.class_eval do
        with_conditions if: :cond_1 do
          with_options presence: true do
            validates :value
          end
        end
      end

      expect(model_class.new(cond_1: true)).not_to be_valid
      expect(model_class.new(cond_1: false)).to be_valid
    end
  end
end
