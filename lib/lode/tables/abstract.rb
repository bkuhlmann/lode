# frozen_string_literal: true

require "dry/monads"
require "refinements/array"

module Lode
  module Tables
    # Provides an abstract table for subclassing.
    class Abstract
      include Dry::Monads[:result]

      using Refinements::Array

      def initialize store, key, setting: Setting.new
        @store = store
        @key = key
        @setting = setting
        @records = store.fetch key, []
      end

      def primary_key = setting.primary_key

      def all = Success records.dup.freeze

      def find value, key: primary_key
        fail NoMethodError,
             "`#{self.class}##{__method__} #{method(__method__).parameters}` must be implemented."
      end

      def create value, key: primary_key
        id = primary_id(value, key:)

        find(id, key:).bind { Failure "Record exists for #{key}: #{id}." }
                      .or do |error|
                        error.include?("Unable to find") ? append(value) : Failure(error)
                      end
      end

      def upsert value, key: primary_key
        fail NoMethodError,
             "`#{self.class}##{__method__} #{method(__method__).parameters}` must be implemented."
      end

      def delete value, key: primary_key
        find(value, key:).fmap do |record|
          records.delete record
          store[key] = records
          record
        end
      end

      protected

      attr_reader :store, :key, :setting, :records

      def primary_id value, key: primary_key
        fail NoMethodError,
             "`#{self.class}##{__method__} #{method(__method__).parameters}` must be implemented."
      end

      def update existing, record
        records.supplant existing, record
        store[key] = records
        Success record
      end

      def append record
        records.append record
        store[key] = records
        Success record
      end
    end
  end
end
