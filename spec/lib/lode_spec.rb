# frozen_string_literal: true

require "spec_helper"

RSpec.describe Lode do
  describe ".new" do
    include_context "with temporary directory"

    let(:path) { temp_dir.join "test.store" }

    it "answers client instance" do
      expect(described_class.new(path)).to be_a(Lode::Client)
    end
  end
end
