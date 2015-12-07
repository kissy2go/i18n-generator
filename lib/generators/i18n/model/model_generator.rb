require 'rails/generators/base'

module I18n
  module Generators
    class ModelGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      # @!attribute
      #   @return [String] name Model name
      argument :name, type: :string

      # Create I18n locale files.
      def create_locale_files
      end
    end
  end
end
