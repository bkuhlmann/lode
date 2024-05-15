# frozen_string_literal: true

require "dry/monads"

module Lode
  module Tables
    # Provides an array-based table for dictionary or hash-like objects.
    class Dictionary < Abstract
      include Dry::Monads[:result]

      def find value, key: primary_key
        records.find { |record| primary_id(record, key:) == value }
               .then do |record|
                 return Success record if record

                 Failure "Unable to find #{key}: #{value.inspect}."
               end
      end

      def upsert value, key: primary_key
        find(value[key]).either(
          -> existing { update existing, value },
          proc { append value }
        )
      end

      protected

      def primary_id(record, key: primary_key) = record[key]
    end
  end
end
