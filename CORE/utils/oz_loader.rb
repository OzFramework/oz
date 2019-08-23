module Oz
  module OzLoader
    @project_modules = []
    @page_stores = []

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
        print "\n=== Loading CORE Directory ===\n" if debug?
        print "Loading CORE/setup.rb\n" if debug?
        ENV['OZ_CORE_DIR'] = "#{__dir__}/../"
        print "CORE location: [#{ENV['OZ_CORE_DIR']}]\n" if debug?
        $world = Object.new unless defined?(Cucumber)
        load_core
        load_libs
        load_project
      end

      def check_gems(required_gems, module_name, *args)
        gem_statuses = required_gems.each_with_object({}){ |gem, hash| hash[gem] = Gem::Specification.any?{|it| it.name == gem} }
        return true unless gem_statuses.any?{|_, was_loaded| !was_loaded}

        warn "Gems:\n  #{gem_statuses.map{|key, value| "#{key}: #{value}"}.join("\n  ")}"
        message = "Use of the #{module_name} requires the gem"
        message << "s #{required_gems.insert(-2, 'and').join(' ')}" if required_gems.size > 1
        message << " #{required_gems.first}" if required_gems.size == 1
        message << ' to be on your gemlist.'
        raise message unless args.include?(:soft_fail)
        false
      end

      def ensure_installed(required_gems, module_name)
        return if check_gems(required_gems, module_name, :soft_fail)

        required_gems.each do |it|
          puts "Installing #{it}"
          Gem.install(it)
        end
      end

      def require_all(directory, pattern: '*.rb')
        puts "Loading #{directory}" if debug?
        source = ENV['OZ_CORE_DIR']
        directory = File.join(source, directory)
        Dir["#{directory}/#{pattern}"].sort.each do |file|
          print "Loading #{file}\n" if debug?
          require file
        end
      end

      # TODO Move this out to router to allow it to handle page loading.
      def recursively_require_all_root_pages(directory)
        source = ENV['OZ_CORE_DIR']
        directory = File.join(source, directory)
        Dir["#{directory}/**/*.rb"].sort.each do |file|
          if file =~ /root_page/
            print "Loading #{file}\n" if debug?
            require file
          end
        end
      end


      # TODO Move this out to router to allow it to handle page loading.
      def recursively_require_all_edge_pages(directory)
        source = ENV['OZ_CORE_DIR']
        directory = File.join(source, directory)
        Dir["#{directory}/**/*.rb"].sort.each do |file|
          unless file =~ /base_page|root_page/
            print "Loading #{file}\n" if debug?
            require file
          end
        end
      end

      # TODO Move this out to router to allow it to handle page loading.
      def recursively_require_all_base_pages(directory)
        source = ENV['OZ_CORE_DIR']
        directory = File.join(source, directory)
        Dir["#{directory}/**/*base_page*.rb"].sort.each do |file|
          print "Loading #{file}\n" if debug?
          require file
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
        require_relative('../elements/_core_element.rb')
        require_relative '../pages/core_page'
        core = %w[./utils ./world_gadgets/router ./world_gadgets ./world_extensions ./metadata ./pages ./helpers]
        core.each(&method(:require_all))
      end

      ##
      # Redefine this method to add a list of libraries extending oz.
      def load_libs; end

      ##
      # Loads paths defined on project_modules.
      def load_project
        warning = ''
        warning << "No project modules defined, please use OzLoader.project_modules = [] to define project override locations\n" if project_modules.empty?
        warning << "No page stores defined, please use OzLoader.page_stores = [] to define page locations\n" if page_stores.empty?
        warn warning unless warning == ''

        @project_modules&.each(&method(:require_all))
        @page_stores&.each(&method(:recursively_require_all_root_pages))
        @page_stores&.each(&method(:recursively_require_all_base_pages))
        @page_stores&.each(&method(:recursively_require_all_edge_pages))
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