module Grapi
  class Config
    def self.load(environment)
      config = YAML.load_file('config/application.yml')[environment]

      if config
        config.keys.each { |key| config[key] = config[key].to_s }
        ENV.update(config)
      end
    end
  end
end
