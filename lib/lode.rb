# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.new.then do |loader|
  loader.tag = File.basename __FILE__, ".rb"
  loader.push_dir __dir__
  loader.setup
end

# Main namespace.
module Lode
  PRIMARY_KEY = :id
  MODES = %i[default thread file max].freeze

  def self.loader(registry = Zeitwerk::Registry) = registry.loader_for __FILE__

  def self.new(...) = Client.new(...)
end
