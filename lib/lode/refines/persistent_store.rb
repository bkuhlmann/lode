# frozen_string_literal: true

require "pstore"
require "refinements/array"

module Lode
  module Refines
    # Refined and enhanced PStore functionality.
    module PersistentStore
      using Refinements::Array

      refine PStore.singleton_class do
        def with path, mode: :default
          case mode
            when :default then new path
            when :thread then new path, true
            when :file then new(path).tap { |instance| instance.ultra_safe = true }
            when :max then new(path, true).tap { |instance| instance.ultra_safe = true }
            else fail PStore::Error, %(Invalid mode. Use: #{MODES.to_usage "or"}.)
          end
        end
      end

      refine PStore do
        def thread_safe? = @thread_safe

        def file_safe? = @ultra_safe
      end
    end
  end
end
