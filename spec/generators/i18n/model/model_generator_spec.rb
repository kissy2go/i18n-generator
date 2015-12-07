require 'spec_helper'
require 'active_model'

# Generators are not automatically loaded by Rails
require 'generators/i18n/model/model_generator'

describe I18n::Generators::ModelGenerator, type: :generator do
  destination File.expand_path('../../../../../tmp', __FILE__)

  before { prepare_destination }

  # Declare ActiveRecord mock class
  class MockModel
    include ActiveModel::Model

    def self.i18n_scope
      :activerecord
    end

    # Return dummy column names
    def self.column_names
      %w{id name email password created_at updated_at}
    end
  end

  # Generator should create locale files.
  def should_create_locale_files_for(locales)
    locales.each do |locale|
      dest_file = file("config/locales/models/#{model_name}/#{locale}.yml")
      expect(dest_file).to exist
      expect(dest_file).to contain(
        [].tap{ |content|
          content << %(#{locale}:)
          content << %(  #{model.i18n_scope}:)
          content << %(    models:)
          content << %(      #{model_name}: "#{model_name.humanize}")
          content << %(    attributes:)
          content << %(      #{model_name}:)
          model.column_names.each do |column|
            content << %(        #{column}: "#{column.humanize}")
          end
        }.join("\n")
      )
    end
  end

  Given(:model) { MockModel }
  Given(:model_name) { model.model_name.i18n_key.to_s }

  Then {
    model_generator = generator [model_name]
    expect(model_generator).to receive(:create_locale_files)
    model_generator.invoke_all
  }

  context 'with declared model name parameter' do
    context 'without options' do
      When { run_generator [model_name] }
      Then { should_create_locale_files_for I18n.available_locales }
    end

    context 'with --locales options' do
      Given(:locales) { %w{ja en} }
      When { run_generator [model_name, '--locales', *locales] }
      Then { should_create_locale_files_for locales }
    end
  end

  context 'with undeclared model name parameter' do
    Given(:model_name) { 'undeclared_model' }
    When { run_generator [model_name] }
    Then {
      expect(file("config/locales/models/#{model_name}")).not_to exist
    }
  end
end
