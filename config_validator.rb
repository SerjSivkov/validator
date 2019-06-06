# frozen_string_literal: true

require 'json-schema'

module Avia
  class ConfigValidator
    attr_reader :error

    def initialize(config: {}, gds_id: nil)
      @config = config
      @gds_id = gds_id
      @error  = ''
      create_formats
    end

    def validate?
      response = JSON::Validator.fully_validate(merge_gds_schema, @config, errors_as_objects: true)
      gets_error_message(response)

      error.present? ? false : true
    end

    protected

    def merge_gds_schema
      schema = gds_schema || base_schema
      schema['properties'].merge!(base_schema['properties'])
      schema
    end

    def gds_schema
      {
        GdsUAPI::Driver::ID                  => load_schema('uapi_schema'),
        GdsFactory::SKYPICKER_DRIVER_ID      => load_schema('skypicker_schema'),
        GdsFactory::SIRENA_DRIVER_ID         => load_schema('sirena_schema'),
        GdsSpecialfare::Driver::ID           => load_schema('specialfare_schema'),
        GdsFactory::NAVITAIRE_DRIVER_ID      => load_schema('navitaire_schema'),
        GdsFactory::FARELOGIX_DRIVER_ID      => load_schema('farelogix_schema'),
        GdsFactory::NDC_AIR_FRANCE_DRIVER_ID => load_schema('ndc_airfrance_schema'),
        NdcTurkmenistanAirline::Driver::ID   => load_schema('ndc_turkmenistan_schema'),
        GdsFactory::AMADEUS_DRIVER_ID        => load_schema('amadeus_schema'),
        GdsSabre::Driver::ID                 => load_schema('sabre_schema'),
        GdsFactory::GALILEO_WS_DRIVER_ID     => load_schema('galileo_schema'),
        GdsFactory::GABRIEL_DRIVER_ID        => load_schema('gabriel_schema')
      }.fetch(@gds_id, nil)
    end

    def base_schema
      load_schema('base_schema')
    end

    def load_schema(file_name)
      JsonSerializer.load(fetch_content("#{file_name}.json"))
    end

    def fetch_content(file_name)
      File.open("#{File.dirname(__FILE__)}/avia_config_item_schemas/#{file_name}", 'rb', &:read)
    end

    def gets_error_message(result)
      result.map { |error| @error += error[:message].gsub(/ in schema [0-9a-zA-Z\-]*$/, '.').gsub(/[\"]+/, "'") }
    end

    def create_formats
      Avia::ConfigItemSchemas::FormatsValidator::CurrencyFormatValidator.invoke
      Avia::ConfigItemSchemas::FormatsValidator::DayTlFormatValidator.invoke
      Avia::ConfigItemSchemas::FormatsValidator::SupplierFormatValidator.invoke
      Avia::ConfigItemSchemas::FormatsValidator::CompanyTimeLimitValidator.invoke
    end
  end
end
