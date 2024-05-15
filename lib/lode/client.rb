# frozen_string_literal: true

require "forwardable"
require "refinements/pathname"

module Lode
  # Provides an enhanced PStore-based client.
  class Client
    extend Forwardable

    using Refinements::Pathname

    attr_reader :path, :store

    delegate %i[register registry] => :configuration

    def initialize path, configuration: Configuration.new
      yield configuration if block_given?

      @path = Pathname(path).make_ancestors
      @configuration = configuration
      @store = configuration.store_for path
    end

    def read(key, &) = transact(__method__, key, &)

    def write(key, &) = transact(:commit, key, &)

    def commit(key, &)
      write(key, &)
    end

    private

    attr_reader :configuration

    def transact mode, key, &block
      store.transaction mode == :read do
        configuration.table_for(store, key).instance_eval(&block)
      end
    end
  end
end
