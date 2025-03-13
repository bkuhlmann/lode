# frozen_string_literal: true

require "pstore"
require "spec_helper"

require SPEC_ROOT.join("support/fixtures/link").to_s

RSpec.describe Lode::Tables::Value do
  using Refinements::Pathname

  subject(:table) { described_class.new store, :links, setting: Lode::Setting[model: record.class] }

  include_context "with temporary directory"

  let(:store) { PStore.new temp_dir.join("test.store") }
  let(:record) { Lode::Fixtures::Link[id: 1, label: "Test", url: "https://example.com/test"] }

  include_examples "with table operations"

  describe "#update" do
    let(:change) { Lode::Fixtures::Link[id: 1, label: "Mod", url: "https://example.com/test"] }

    it "updates record" do
      store.transaction do
        table.create record
        table.update change

        expect(table.all).to be_success([change])
      end
    end

    it "answers updated record" do
      store.transaction do
        table.create record
        expect(table.update(change)).to be_success(change)
      end
    end

    it "answers failure when when record can't be found" do
      store.transaction do
        table.update record
        expect(table.update(record)).to be_failure("Unable to find id: 1.")
      end
    end
  end

  describe "#upsert" do
    it "updates existing record" do
      update = record.with label: "Different"

      store.transaction do
        table.upsert record
        table.upsert update

        expect(table.all).to be_success([update])
      end
    end

    it "answers updated record" do
      update = record.with label: "Different"

      store.transaction do
        table.upsert record
        expect(table.upsert(update)).to be_success(update)
      end
    end
  end
end
