module ModelValidations
  RSpec::Matchers.define :have_field do |name|
    match do |document|
      document.class.fields.include?(name)
    end

    description do
      "have field '#{name.to_s}'"
    end

    failure_message do |document|
      "expected that #{document.class} to have field '#{name}'"
    end
  end

  RSpec::Matchers.define :validate_presence_of do |name|
    match do |document|
      document.validate
      document._errors.include? name
    end

    description do
      "validate presence of '#{name.to_s}'"
    end

    failure_message do |document|
      "expected that #{document.class} validate presence of '#{name}'"
    end
  end
end
