# frozen_string_literal: true

require "dry/monads"

module Lode
  module Tables
    # Provides an array-based table for value objects.
    class Value < Abstract
      include Dry::Monads[:result]

      def upsert value, key: primary_key
        record = record_for value

        find(primary_id(record, key:)).either(
          -> existing { update existing, record },
          proc { append record }
        )
      end

      protected

      def primary_id(record, key: primary_key) = record.public_send(key)

      private

      # :reek:FeatureEnvy
      def record_for value
        model = setting.model
        value.is_a?(model) ? value : model[**value.to_h]
      end
    end
  end
end
