# frozen_string_literal: true

require "pstore"
require "spec_helper"

RSpec.describe Lode::Tables::Hash do
  include Dry::Monads[:result]

  subject(:table) { described_class.new store, :links }

  include_context "with temporary directory"

  let(:store) { PStore.new temp_dir.join("test.store") }
  let(:record) { {id: 1, label: "Test", url: "https://example.com/test"} }

  include_examples "with table operations"

  describe "#update" do
    let(:change) { record.merge label: "Mod" }

    it "updates record" do
      store.transaction do
        table.create record
        table.update change

        expect(table.all).to eq(Success([change]))
      end
    end

    it "answers updated record" do
      store.transaction do
        table.create record
        expect(table.update(change)).to eq(Success(change))
      end
    end

    it "answers failure when when record can't be found" do
      store.transaction do
        table.update record
        expect(table.update(record)).to eq(Failure("Unable to find id: 1."))
      end
    end
  end

  describe "#upsert" do
    it "updates existing record" do
      update = record.merge label: "Different"

      store.transaction do
        table.upsert record
        table.upsert update

        expect(table.all).to eq(Success([update]))
      end
    end

    it "answers updated record" do
      update = record.merge label: "Different"

      store.transaction do
        table.upsert record
        expect(table.upsert(update)).to eq(Success(update))
      end
    end
  end
end
