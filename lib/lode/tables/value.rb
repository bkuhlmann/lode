# frozen_string_literal: true

require "dry/monads"

module Lode
  module Tables
    # Provides an array-based table for value objects.
    class Value < Abstract
      include Dry::Monads[:result]

      def upsert change, key: primary_key
        record = record_for change

        find(primary_id(record, key:)).either(
          -> existing { revise existing, record },
          proc { append record }
        )
      end

      protected

      def primary_id(record, key: primary_key) = record.public_send(key)

      private

      # :reek:FeatureEnvy
      def record_for change
        model = setting.model
        change.is_a?(model) ? change : model[**change.to_h]
      end
    end
  end
end
