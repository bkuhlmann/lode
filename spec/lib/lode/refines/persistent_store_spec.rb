# frozen_string_literal: true

require "spec_helper"

RSpec.describe Lode::Refines::PersistentStore do
  using described_class

  subject(:store) { PStore.new path }

  include_context "with temporary directory"

  let(:path) { temp_dir.join "test.store" }

  describe ".with" do
    it "answers instance in default mode" do
      store = PStore.with path

      expect(store.inspect).to match(
        /@filename=#{path.inspect}.+@ultra_safe=false.+@thread_safe=false.+/
      )
    end

    it "answers instance in thread safe mode" do
      store = PStore.with path, mode: :thread
      expect(store.thread_safe?).to be(true)
    end

    it "answers instance in file safe mode" do
      store = PStore.with path, mode: :file
      expect(store.file_safe?).to be(true)
    end

    it "answers instance in maximum safety mode" do
      store = PStore.with path, mode: :max

      expect(store.inspect).to match(
        /@filename=#{path.inspect}.+@ultra_safe=true.+@thread_safe=true.+/
      )
    end

    it "fails with invalid mode" do
      expectation = proc { PStore.with path, mode: :bogus }

      expect(&expectation).to raise_error(
        PStore::Error,
        "Invalid mode. Use: :default, :thread, :file, or :max."
      )
    end
  end

  describe "#thread_safe?" do
    it "answers false by default" do
      expect(store.thread_safe?).to be(false)
    end

    it "answers true when set" do
      store = PStore.new path, true
      expect(store.thread_safe?).to be(true)
    end
  end

  describe "#file_safe?" do
    it "answers false by default" do
      expect(store.file_safe?).to be(false)
    end

    it "answers true when set" do
      store = PStore.with path, mode: :file
      expect(store.file_safe?).to be(true)
    end
  end
end
