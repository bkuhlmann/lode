# frozen_string_literal: true

require "pstore"

module Lode
  # Models the default configuration.
  Configuration = Struct.new :store, :mode, :table, :primary_key, :registry do
    using Refines::PersistentStore
    using Refinements::Arrays

    def initialize store: PStore,
                   mode: :default,
                   table: Tables::Dictionary,
                   primary_key: PRIMARY_KEY,
                   registry: {}
      super
    end

    def store_for(path) = store.with(path, mode:)

    def table_for store, key, setting: Setting.new
      table.new store, key, setting: registry.fetch(key, setting)
    end

    def register key, model: Hash, primary_key: PRIMARY_KEY
      registry[key] = Setting[model:, primary_key:]
      self
    end
  end
end
