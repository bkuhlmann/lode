# frozen_string_literal: true

require "pstore"
require "spec_helper"

RSpec.describe Lode::Tables::Dictionary do
  include Dry::Monads[:result]

  subject(:table) { described_class.new store, :links }

  include_context "with temporary directory"

  let(:store) { PStore.new temp_dir.join("test.store") }
  let(:record) { {id: 1, label: "Test", url: "https://example.com/test"} }

  include_examples "with table operations"

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
