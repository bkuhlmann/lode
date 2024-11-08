# frozen_string_literal: true

require "spec_helper"

RSpec.describe Lode::Configuration do
  subject(:configuration) { described_class.new }

  describe "#initialize" do
    it "answers default attributes" do
      expect(configuration).to eq(
        described_class[
          store: PStore,
          mode: :default,
          table: Lode::Tables::Hash,
          primary_key: :id,
          registry: {}
        ]
      )
    end
  end

  describe "#register" do
    it "registers table model and primary key" do
      configuration.register :users, model: Hash, primary_key: :external_id

      expect(configuration.registry).to eq(
        users: Lode::Setting[model: Hash, primary_key: :external_id]
      )
    end

    it "answers itself" do
      instance = configuration.register :users, model: Hash, primary_key: :external_id
      expect(instance).to be_a(described_class)
    end
  end

  describe "#store_for" do
    include_context "with temporary directory"

    let(:path) { temp_dir.join "test.store" }

    it "answers store in default mode" do
      store = configuration.store_for path

      expect(store.inspect).to match(
        /@filename=#{path.inspect}.+@ultra_safe=false.+@thread_safe=false.+/
      )
    end
  end

  describe "#table_for" do
    include_context "with temporary directory"

    let(:path) { temp_dir.join "test.store" }

    it "answers table for key and store" do
      configuration.register :test
      store = configuration.store_for path

      store.transaction do
        table = configuration.table_for store, :test
        expect(table).to be_a(Lode::Tables::Hash)
      end
    end

    it "answers default value when key isn't registered" do
      store = configuration.store_for path

      store.transaction do
        table = configuration.table_for store, :test
        expect(table).to be_a(Lode::Tables::Hash)
      end
    end
  end
end
