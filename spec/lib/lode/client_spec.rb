# frozen_string_literal: true

require "dry/monads"
require "pstore"
require "spec_helper"

RSpec.describe Lode::Client do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:client) { described_class.new path }

  include_context "with temporary directory"

  let(:path) { temp_dir.join "test.store" }
  let(:record) { {id: 1, label: "Test", url: "https://example.com/test"} }

  describe "#initialize" do
    it "answers instance with custom block configuration" do
      client = described_class.new path do |config|
        config.mode = :thread
        config.table = Lode::Tables::Value
        config.primary_key = :slug
      end

      expect(client.inspect).to include(
        "store=PStore, mode=:thread, table=Lode::Tables::Value, primary_key=:slug, registry={}"
      )
    end

    it "answers instance with custom keyword configuration" do
      configuration = Lode::Configuration[
        mode: :thread,
        table: Lode::Tables::Value,
        primary_key: :slug
      ]

      client = described_class.new(path, configuration:)

      expect(client.inspect).to include(
        "store=PStore, mode=:thread, table=Lode::Tables::Value, primary_key=:slug, registry={}"
      )
    end

    it "ensures nested path ancestors exist" do
      path = temp_dir.join "one/two/test.store"
      described_class.new path

      expect(path.parent.exist?).to be(true)
    end
  end

  describe "#register" do
    it "registers table setting" do
      client.register :test
      expect(client.registry).to eq(test: Lode::Setting.new)
    end
  end

  describe "#registry" do
    it "answers default registry" do
      expect(client.registry).to eq({})
    end

    it "answers custom registry" do
      client = described_class.new(path).tap { |instance| instance.register :links }
      expect(client.registry).to eq(links: Lode::Setting.new)
    end
  end

  describe "#path" do
    it "answers storage path" do
      expect(client.path).to eq(path)
    end
  end

  describe "#store" do
    it "answers storage instance" do
      expect(client.store).to be_a(PStore)
    end
  end

  describe "#read" do
    let(:records) { client.commit(:links, &:all) }

    it "answers found record" do
      local_record = record
      client.commit(:links) { upsert local_record }
      result = client.read(:links) { find local_record[:id] }

      expect(result).to eq(Success(record))
    end

    it "fails when attempting mutation" do
      local_record = record
      expectation = proc { client.read(:links) { upsert local_record } }

      expect(&expectation).to raise_error(PStore::Error, /read-only/)
    end
  end

  describe "#commit" do
    let(:records) { client.commit(:links, &:all) }

    it "creates and updates a record" do
      modification = record.merge label: "Updated Test"
      local_record = record

      client.commit :links do
        upsert(local_record).fmap { upsert modification }
      end

      expect(records).to eq(Success([modification]))
    end

    it "creates and deletes a record" do
      local_record = record

      client.commit :links do
        upsert local_record
        delete local_record[:id]
      end

      expect(records).to eq(Success([]))
    end
  end

  describe "#write" do
    let(:records) { client.write(:links, &:all) }

    it "creates and updates a record" do
      modification = record.merge label: "Updated Test"
      local_record = record

      client.write :links do
        upsert(local_record).fmap { upsert modification }
      end

      expect(records).to eq(Success([modification]))
    end

    it "creates and deletes a record" do
      local_record = record

      client.write :links do
        upsert local_record
        delete local_record[:id]
      end

      expect(records).to eq(Success([]))
    end
  end
end
