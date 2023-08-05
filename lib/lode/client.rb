# frozen_string_literal: true

require "forwardable"

module Lode
  # Provides an enhanced PStore-based client.
  class Client
    extend Forwardable

    attr_reader :path, :store

    delegate %i[register registry] => :configuration

    def initialize path, configuration: Configuration.new
      yield configuration if block_given?

      @path = path
      @configuration = configuration
      @store = configuration.store_for path
    end

    def read(key, &) = transact(__method__, key, &)

    def commit(key, &) = transact(__method__, key, &)

    private

    attr_reader :configuration

    def transact(mode, key, &)
      store.transaction mode == :read do
        configuration.table_for(store, key).instance_eval(&)
      end
    end
  end
end
