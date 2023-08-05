# frozen_string_literal: true

require "pstore"
require "spec_helper"

RSpec.describe Lode::Tables::Abstract do
  include Dry::Monads[:result]

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
      store.transaction { expect(table.all).to eq(Success([])) }
    end

    it "answers frozen records" do
      store.transaction { expect(table.all.success).to be_frozen }
    end
  end

  describe "#find" do
    it "fails when not implemented" do
      store.transaction do
        expectation = proc { table.find 1 }

        expect(&expectation).to raise_error(
          NotImplementedError,
          /Lode::Tables::Abstract#find \[\[:req, :value\], \[:key, :key\]\]` must be implemented./
        )
      end
    end
  end

  describe "#upsert" do
    it "fails when not implemented" do
      store.transaction do
        expectation = proc { table.upsert record }

        expect(&expectation).to raise_error(
          NotImplementedError,
          /Lode::Tables::Abstract#upsert \[\[:req, :value\], \[:key, :key\]\]` must be implemented./
        )
      end
    end
  end

  describe "#delete" do
    it "fails when not implemented" do
      store.transaction do
        expectation = proc { table.delete 1 }

        expect(&expectation).to raise_error(
          NotImplementedError,
          /Lode::Tables::Abstract#find \[\[:req, :value\], \[:key, :key\]\]` must be implemented./
        )
      end
    end
  end
end
