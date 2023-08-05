# frozen_string_literal: true

require "spec_helper"

RSpec.describe Lode::Setting do
  subject(:setting) { described_class.new }

  describe "#initialize" do
    it "answers defaults" do
      expect(setting).to eq(described_class[model: Hash, primary_key: :id])
    end
  end
end
