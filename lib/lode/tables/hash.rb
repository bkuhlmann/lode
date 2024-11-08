# frozen_string_literal: true

require "dry/monads"

module Lode
  module Tables
    # Provides an array-based table for hash objects.
    class Hash < Abstract
      include Dry::Monads[:result]

      def upsert change, key: primary_key
        find(change[key], key:).either(
          -> existing { revise existing, change },
          proc { append change }
        )
      end

      protected

      def primary_id(record, key: primary_key) = record[key]
    end
  end
end
