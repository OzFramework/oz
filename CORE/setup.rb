
#Flip this to true if you are having load-order issues.
# DEBUG_LOADING = true
DEBUG_LOADING = false

print "\n=== Loading CORE Directory ===\n" if DEBUG_LOADING
print "Loading CORE/setup.rb\n" if DEBUG_LOADING

ENV['OZ_CORE_DIR'] = File.dirname(__FILE__)
print "CORE location: [#{ENV['OZ_CORE_DIR']}]\n" if DEBUG_LOADING

$world = Object.new() unless defined?(Cucumber)

def append_to_world(module_name)
  if defined?(Cucumber)
    print "We are running cucumber, mixing #{module_name} into the [World] object!\n" if DEBUG_LOADING
    World(module_name)
  else
    print "We are not running cucumber, mixing #{module_name} into an empty [$world] object!\n" if DEBUG_LOADING
    $world.extend(module_name)
  end
end

def require_all(directory)
  source = File.dirname(__FILE__)
  directory = File.join(source, directory)
  Dir["#{directory}/*.rb"].each { |file|
    print "Loading #{file}\n" if DEBUG_LOADING
    require file
  }
end

def recursively_require_all_edge_pages(directory)
  source = File.dirname(__FILE__)
  directory = File.join(source, directory)
  Dir["#{directory}/**/*.rb"].each { |file|
    unless file =~ /base_page|root_page/
      print "Loading #{file}\n" if DEBUG_LOADING
      require file
    end
  }
end

def recursively_require_all_base_pages(directory)
  source = File.dirname(__FILE__)
  directory = File.join(source, directory)
  Dir["#{directory}/**/*.rb"].each { |file|
    if file =~ /base_page/
      print "Loading #{file}\n" if DEBUG_LOADING
      require file
    end
  }
end

require_all('./utils')
require_all('./world_gadgets/router')
require_all('./world_gadgets')
require_all('./world_extensions')
require_relative('./elements/_core_element.rb')
require_all('./pages')

require_all('./step_definitions') if defined?(Cucumber)