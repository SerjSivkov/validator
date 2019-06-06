# frozen_string_literal: true

module Avia
  module ConfigItemSchemas
    module FormatsValidator
      class CurrencyFormatValidator
        ALL_CURRENCY = %w(
        UAH RUR EUR USD AUD AZN GBP AMD BYR BGN BRL HUF DKK INR KZT CAD KGS CNY
        LVL LTL MDL NOK PLN RON XDR SGD TJS TRY TMT UZS CZK SEK CHF ZAR KRW JPY
        BTC BYN HKD RUB AED THB
      ).freeze

        def self.invoke
          JSON::Validator.register_format_validator('currency', lambda { |currency|
            unless ALL_CURRENCY.include?(currency)
              raise(JSON::Schema::CustomFormatError.new('Currency not a found'))
            end
          })
        end
      end
    end
  end
end
