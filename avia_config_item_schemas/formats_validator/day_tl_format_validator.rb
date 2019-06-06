# frozen_string_literal: true

module Avia
  module AviaConfigItemSchemas
    module FormatsValidator
      class DayTlFormatValidator
        def self.invoke
          JSON::Validator.register_format_validator('day-tl', lambda { |day_tl|
            day_tl_array = day_tl.split(':')
            if day_tl_array.count != 2                  ||
               !day_tl_array[0].length.in?(1..2)        ||
                /\D/.match(day_tl_array.first).present? ||
               day_tl_array.first.to_i > 23             ||
               !day_tl_array[1].length.in?(1..2)        ||
                /\D/.match(day_tl_array.last).present?  ||
               day_tl_array.last.to_i > 59

              raise(JSON::Schema::CustomFormatError.new('Day_tl not a valid'))
            end
          })
        rescue raise(JSON::Schema::CustomFormatError.new('Day_tl not a valid'))
        end
      end
    end
  end
end
