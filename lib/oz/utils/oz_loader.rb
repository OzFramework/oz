module Oz
  module OzLoader
    @project_modules = []
    @page_stores = []
    @source = ''

    class << self
      attr_accessor :debug, :rspec, :world
      attr_reader :project_modules
      attr_reader :page_stores

      def debug?
        @debug
      end

      def rspec?
        @rspec
      end

      def load
        if debug?
          print "\n=== Loading CORE Directory ===\n" +
                    "Loading CORE/setup.rb\n" +
                    "CORE location: [#{ENV['OZ_CORE_DIR']}]\n"
        end
        $world = Object.new unless defined?(Cucumber)
        load_core
        load_libs
        load_project
      end

      def check_gems(required_gems, module_name, *args)
        gem_statuses = check_availability(required_gems)
        return true unless gem_statuses.any?{|_, was_loaded| !was_loaded}

        warn "Gems:\n  #{gem_statuses.map{|key, value| "#{key}: #{value}"}.join("\n  ")}"
        raise error_message(module_name, required_gems) unless args.include?(:soft_fail)

        false
      end

      def error_message(module_name, required_gems)
        message = "Use of the #{module_name} requires the gem"
        message << "s #{required_gems.insert(-2, 'and').join(' ')}" if required_gems.size > 1
        message << " #{required_gems.first}" if required_gems.size == 1
        message << ' to be on your gemlist.'
        message
      end

      def check_availability(required_gems)
        available_gems = Gem::Specification.map(&:name)
        required_gems.each_with_object({}){ |gem, hash| hash[gem] = available_gems.include?(gem) }
      end

      def ensure_installed(required_gems, module_name)
        return if check_gems(required_gems, module_name, :soft_fail)

        required_gems.each do |it|
          puts "Installing #{it}"
          Gem.install(it)
        end
      end

      def files(directory)
        return @files if @last_directory == directory

        @last_directory = directory
        puts "Loading #{directory}" if debug?
        directory = "#{@source}#{directory}"
        @files = Dir["#{directory}/**/*.rb"].sort
      end

      def require_all(directory, &block)
        files = files(directory)
        files = files.select { |file| block.call(file) } if block_given?
        files.each do |file|
          print "Loading #{file}\n" if debug?
          require file
        end
      end

      def build_page_stores
        @page_stores.each do |store|
          recursively_require_all_root_pages(store)
          recursively_require_all_base_pages(store)
          recursively_require_all_edge_pages(store)
        end
      end

      def recursively_require_all_root_pages(directory)
        require_all(directory) do |file|
          file =~ /root_page/
        end
      end

      def recursively_require_all_base_pages(directory)
        require_all(directory) do |file|
          file =~ /base_page/
        end
      end

      def recursively_require_all_edge_pages(directory)
        require_all(directory) do |file|
          file !~ /base|root_page/
        end
      end


      ##
      # Does nothing if rspec is set to true to make unit testing oz world modules possible.
      def append_to_world(module_name)
        return puts 'Using RSpec, skipping world injection' if rspec?

        if defined?(Cucumber)
          print "We are running cucumber, mixing #{module_name} into the [World] object!\n" if debug?
          @world.World(module_name)
        else
          print "We are not running cucumber, mixing #{module_name} into an empty [$world] object!\n" if debug?
          $world.extend(module_name)
        end
      end

      def load_core
        @source = "#{__dir__}/../"
        require_relative('../elements/_core_element.rb')
        require_relative '../pages/core_page'
        core = %w[./utils ./world_gadgets/router ./world_gadgets ./world_extensions ./metadata ./pages ./helpers ./error]
        core.each(&method(:require_all))
        @source = '' # Set source back to pwd after this.
      end

      ##
      # Redefine this method to add a list of libraries extending oz.
      def load_libs; end

      ##
      # Loads paths defined on project_modules.
      def load_project
        load_warning = load_warnings
        warn load_warning unless load_warning == ''

        @project_modules&.each(&method(:require_all))
        build_page_stores
      end

      def load_warnings
        warning = ''
        warning << "No project modules defined, please use OzLoader.project_modules = [] to define project override locations\n" if project_modules.empty?
        warning << "No page stores defined, please use OzLoader.page_stores = [] to define page locations\n" if page_stores.empty?
        warning
      end

      ##
      # Raises a warning explaining a deprecation and returns the offending caller
      def deprecated(method_name, dep_type: 'Main Context', fix: nil)
        # This gunk allows me to figure out which non-library thing called the deprecated method.
        my_caller = caller_locations.map(&:to_s).reject{ |it| (it =~ /ruby-[\d\.]+\/(?:lib|gems|bin)/) }[-1]
        warn("Calling #{method_name} via #{dep_type} is deprecated, caller was #{my_caller}")
        warn(fix) if fix
      end

      def prevent_shifting_arrays(instance_variable)
        old_method = instance_variable.method(:<<)
        instance_variable.define_singleton_method(:<<) do |object|
          raise(ArgumentError, 'Tried to left shift an array into a module store.  Only supports 1 dimensional arrays, use concat to add a list of modules at once') if object.is_a? Enumerable
          old_method.call(object)
        end
      end
    end
    prevent_shifting_arrays(@project_modules)
    prevent_shifting_arrays(@page_stores)
    DEPRECATED_METHODS = %i[require_all recursively_require_all_edge_pages recursively_require_all_base_pages].freeze
  end

  Loader = OzLoader
end

Oz::OzLoader::DEPRECATED_METHODS.each do |method|
  define_singleton_method(method) do |directory|
    Oz::OzLoader.deprecated(method, fix: "Use OzLoader.#{method}")
    Oz::OzLoader.send(method, directory)
  end
end

def append_to_world(module_name)
  Oz::OzLoader.world = self
  Oz::OzLoader.deprecated(__method__, fix: "Use OzLoader.#{__method__}")
  Oz::OzLoader.append_to_world(module_name)
end
