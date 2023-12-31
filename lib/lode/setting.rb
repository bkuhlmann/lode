# frozen_string_literal: true

module Lode
  # Defines a configuration setting.
  Setting = Data.define :model, :primary_key do
    def initialize model: Hash, primary_key: PRIMARY_KEY
      super
    end
  end
end
