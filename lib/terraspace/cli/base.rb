class Terraspace::CLI
  class Base
    include Terraspace::Util::Logging

    def initialize(options={})
      @options = options
      @mod = Terraspace::Mod.new(options[:mod]) # mod metadata
      @mod.check_exist!
    end
  end
end
