require 'rails/generators/base'

module I18n
  module Generators
    class ModelGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      # @!attribute
      #   @return [String] name Model name
      argument :name, type: :string, banner: 'model_name'

      class_option :locales, type: :array,
        banner:  I18n.available_locales.join(' '),
        default: I18n.available_locales

      # Create I18n locale files.
      def create_locale_files
        @i18n_scope = model.i18n_scope.to_s
        @i18n_key   = model.model_name.i18n_key.to_s
        @columns    = model.column_names

        options[:locales].each do |locale|
          @locale = locale
          locale_file = File.join(
            'config/locales/models', model_name.underscore, "#{@locale}.yml"
          )
          template 'locale.yml', locale_file
        end
      rescue NameError
        puts "#{model_name} is undefined."
      end

      private

      # Return model name
      #
      # @return [String] Model name
      def model_name
        name.classify
      end

      # Return model class.
      #
      # @return [Class] Model class
      def model
        model_name.constantize
      end
    end
  end
end
