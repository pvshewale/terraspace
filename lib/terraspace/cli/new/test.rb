class Terraspace::CLI::New
  class Test < Thor::Group
    include Thor::Actions
    include Terraspace::CLI::New::Helpers

    argument :name

    def self.options
      [
        [:force, aliases: %w[y], type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
        [:test_name, desc: "Test name. Defaults to the project, module or stack name"],
        [:type, default: "project", desc: "project, stack or module"],
      ]
    end
    options.each { |args| class_option(*args) }

  private
    def type
      valid_types = %w[project stack module]
      type = @options[:type]
      valid_types.include?(type) ? type : "project" # fallback to project if user provides invalid type
    end

    def test_name
      options[:test_name] || name
    end

    def dest
      map = {
        project: ".", # Terraspace.root
        stack:   "app/stacks/#{name}",
        module:  "app/modules/#{name}",
      }
      map[type.to_sym]
    end

    def test_template_source(template, type)
      source = Terraspace::CLI::New::Source::Test.new(self, @options)
      source.set_source_paths(template, type)
    end

  public

    def create
      test_template_source(@options[:lang], type)
      puts "=> Creating #{type} test: #{name}"
      directory ".", dest
    end
  end
end
