# frozen_string_literal: true

require "spec_helper"

RSpec.describe Lode do
  describe ".loader" do
    it "eager loads" do
      expectation = proc { described_class.loader.eager_load force: true }
      expect(&expectation).not_to raise_error
    end

    it "answers unique tag" do
      expect(described_class.loader.tag).to eq("lode")
    end
  end

  describe ".new" do
    include_context "with temporary directory"

    let(:path) { temp_dir.join "test.store" }

    it "answers client instance" do
      expect(described_class.new(path)).to be_a(described_class::Client)
    end
  end
end
