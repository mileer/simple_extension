module Spree
  module SpreeSimpleExt
    class Config
      include Singleton
      include PreferenceAccess
      
      class << self
        def instance
          return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
          SimpleConfiguration.find_or_create_by_name("Simple configuration")
        end
      end
    end
  end
end