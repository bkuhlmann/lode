# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.for_gem.setup

# Main namespace.
module Lode
  PRIMARY_KEY = :id
  MODES = %i[default thread file max].freeze

  def self.new(...) = Client.new(...)
end
