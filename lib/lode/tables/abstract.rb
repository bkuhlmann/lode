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

      def find id, key: primary_key
        records.find { |record| primary_id(record, key:) == id }
               .then do |record|
                 return Success record if record

                 Failure "Unable to find #{key}: #{id.inspect}."
               end
      end

      def create record, key: primary_key
        id = primary_id(record, key:)

        find(id, key:).bind { Failure "Record exists for #{key}: #{id}." }
                      .or do |error|
                        return append record if error.include? "Unable to find"

                        Failure error
                      end
      end

      def update change, key: primary_key
        id = primary_id(change, key:)
        find(id, key:).bind { |existing| revise existing, change }
      end

      def upsert record, key: primary_key
        fail NoMethodError,
             "`#{self.class}##{__method__} #{method(__method__).parameters}` must be implemented."
      end

      def delete id, key: primary_key
        find(id, key:).fmap do |record|
          records.delete record
          store[key] = records
          record
        end
      end

      protected

      attr_reader :store, :key, :setting, :records

      def primary_id record, key: primary_key
        fail NoMethodError,
             "`#{self.class}##{__method__} #{method(__method__).parameters}` must be implemented."
      end

      def revise existing, change
        records.supplant existing, change
        store[key] = records
        Success change
      end

      def append record
        records.append record
        store[key] = records
        Success record
      end
    end
  end
end
