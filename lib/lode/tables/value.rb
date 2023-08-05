# frozen_string_literal: true

require "dry/monads"

module Lode
  module Tables
    # Provides an array-based table for value objects.
    class Value < Abstract
      include Dry::Monads[:result]

      def find value, key: primary_key
        records.find { |record| record.public_send(key) == value }
               .then do |record|
                 return Success record if record

                 Failure "Unable to find #{key}: #{value.inspect}."
               end
      end

      def upsert value, key: primary_key
        record = record_for value

        find(record.public_send(key)).either(
          -> existing { update existing, record },
          proc { append record }
        )
      end

      private

      # :reek:FeatureEnvy
      def record_for value
        model = setting.model
        value.is_a?(model) ? value : model[**value.to_h]
      end
    end
  end
end
