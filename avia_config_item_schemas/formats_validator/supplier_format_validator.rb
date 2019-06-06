# frozen_string_literal: true

module Avia
  module ConfigItemSchemas
    module FormatsValidator
      class SupplierFormatValidator
        def self.invoke
          JSON::Validator.register_format_validator('supplier-length', lambda { |supplier|
            if supplier.length != 2
              raise(JSON::Schema::CustomFormatError.new('Supplier length must be 2'))
            end
          })
        end
      end
    end
  end
end
