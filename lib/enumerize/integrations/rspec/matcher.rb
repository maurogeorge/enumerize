require 'active_support/core_ext/hash/indifferent_access'

module Enumerize
  module Integrations
    module RSpec
      class Matcher

        def initialize(attr)
          self.attr = attr
        end

        def in(*values)
          self.values = values
          self
        end

        def with_default(default)
          self.default = default.to_s
          self
        end

        def failure_message
          "Expected #{expectation}"
        end

        def description
          description  = "define enumerize :#{attr} in: #{quote_values(values)}"
          description += " with #{default.inspect} as default value" if default

          description
        end

        def matches?(subject)
          self.subject = subject
          matches      = true

          matches &= matches_attributes?
          matches &= matches_default_value? if default

          matches
        end

        private
        attr_accessor :attr, :values, :subject, :default

        def expectation
          "#{subject.class.name} to #{description}"
        end

        def matches_attributes?
          matches_array_attributes? || matches_hash_attributes?
        end

        def matches_array_attributes?
          sorted_values == enumerized_values
        end

        def matches_hash_attributes?
          return unless values.first.respond_to?(:invert)
          _values = values.first.invert.with_indifferent_access
          _value_hash = value_hash.with_indifferent_access
          _values.map { |k, v| _value_hash[k.to_s] == v; }
        end

        def matches_default_value?
          default == enumerized_default
        end

        def sorted_values
          @sorted_values ||=values.map(&:to_s).sort
        end

        def enumerized_values
          @enumerized_values ||= attributes.values.sort
        end

        def enumerized_default
          @enumerized_default ||= attributes.default_value
        end

        def value_hash
          @value_hash ||= attributes.instance_variable_get('@value_hash')
        end

        def attributes
          subject.class.enumerized_attributes.attributes[attr.to_s]
        end

        def quote_values(values)
          sorted_values.map(&:inspect).join(', ')
        end
      end
    end
  end
end
