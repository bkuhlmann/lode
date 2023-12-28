# frozen_string_literal: true

require "pstore"
require "spec_helper"

require SPEC_ROOT.join("support/fixtures/link").to_s

RSpec.describe Lode::Tables::Value do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:table) { described_class.new store, :links, setting: Lode::Setting[model: record.class] }

  include_context "with temporary directory"

  let(:store) { PStore.new temp_dir.join("test.store") }
  let(:record) { Lode::Fixtures::Link[id: 1, label: "Test", url: "https://example.com/test"] }

  include_examples "with table operations"

  describe "#upsert" do
    it "updates existing record" do
      update = record.with label: "Different"

      store.transaction do
        table.upsert record
        table.upsert update

        expect(table.all).to eq(Success([update]))
      end
    end

    it "answers updated record" do
      update = record.with label: "Different"

      store.transaction do
        table.upsert record
        expect(table.upsert(update)).to eq(Success(update))
      end
    end
  end
end
