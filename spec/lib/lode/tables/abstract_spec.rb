# frozen_string_literal: true

require "pstore"
require "spec_helper"

RSpec.describe Lode::Tables::Abstract do
  subject(:table) { described_class.new store, :links }

  include_context "with temporary directory"

  let(:store) { PStore.new temp_dir.join("test.store") }
  let(:record) { {id: 1, label: "Test", url: "https://example.com/test"} }

  describe "#primary_key" do
    it "answers primary key" do
      store.transaction { expect(table.primary_key).to eq(:id) }
    end
  end

  describe "#all" do
    it "answers records" do
      store.transaction { expect(table.all).to be_success([]) }
    end

    it "answers frozen records" do
      store.transaction { expect(table.all.success).to be_frozen }
    end
  end

  describe "#find" do
    it "answers failure when not found" do
      store.transaction { expect(table.find(1)).to be_failure("Unable to find id: 1.") }
    end
  end

  describe "#create" do
    it "fails when not implemented" do
      store.transaction do
        expectation = proc { table.create record }

        expect(&expectation).to raise_error(
          NoMethodError,
          /#primary_id \[\[:req, :record\], \[:key, :key\]\]` must be implemented./
        )
      end
    end
  end

  describe "#update" do
    it "fails when not implemented" do
      store.transaction do
        expectation = proc { table.update record }

        expect(&expectation).to raise_error(
          NoMethodError,
          /#primary_id \[\[:req, :record\], \[:key, :key\]\]` must be implemented./
        )
      end
    end
  end

  describe "#upsert" do
    it "fails when not implemented" do
      store.transaction do
        expectation = proc { table.upsert record }

        expect(&expectation).to raise_error(
          NoMethodError,
          /#upsert \[\[:req, :record\], \[:key, :key\]\]` must be implemented./
        )
      end
    end
  end

  describe "#delete" do
    it "answers failure when not found" do
      store.transaction { expect(table.delete(1)).to be_failure("Unable to find id: 1.") }
    end
  end
end
