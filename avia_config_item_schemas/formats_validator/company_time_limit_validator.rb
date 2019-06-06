# frozen_string_literal: true

module Avia
  module ConfigItemSchemas
    module FormatsValidator
      class CompanyTimeLimitValidator
        TIME_PERIOD_REGEX = /^\d+-(\d+|\*)$/.freeze

        def self.invoke
          JSON::Validator.register_format_validator('company-time-limit', lambda { |company_time_limit|
            wrong_supplier_iatas = company_time_limit.keys.find_all { |supplier| supplier.length != 2 }
            if wrong_supplier_iatas.present?
              raise(JSON::Schema::CustomFormatError.new("Wrong supplier IATA format. Expected `XX` format. Got `#{wrong_supplier_iatas}`"))
            end

            company_time_limit.values.each do |timelimit_setting|
              wrong_time_periods = timelimit_setting.keys.find_all { |time_preiod| !TIME_PERIOD_REGEX.match?(time_preiod) }
              if wrong_time_periods.present?
                raise(JSON::Schema::CustomFormatError.new("Wrong time periods specified `#{wrong_time_periods}`"))
              end

              wrong_hours = timelimit_setting.values.find_all { |hours| hours.class != Integer }
              if wrong_hours.present?
                raise(JSON::Schema::CustomFormatError.new("Hours must be of Integer. Got `#{wrong_hours}`"))
              end
            end
          })
        rescue raise(JSON::Schema::CustomFormatError.new('Wrong format for `company_time_limit`'))
        end
      end
    end
  end
end
