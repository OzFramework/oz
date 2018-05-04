
module CoreUtils

  def self.find_class(name)
    if name.class == String
      name = name.split(" ").map{|word| word.strip.capitalize}.join('')
    end
    return Kernel.const_get(name)
  end

  def self.recursively_print_hash(hash, truncate=false,indent='')
    print "#{indent}{\n"
    hash.each_pair do |key, value|
      if value.class == Hash
        print "#{indent}#{key} =>\n"
        recursively_print_hash(value, truncate, indent+"    ")
      elsif value.class == Array
        print "#{indent}#{key} =>\n"
        recursively_print_array(value, truncate, indent+"    ")
      elsif value.class < Struct
        print "#{indent}#{key} =>\n"
        recursively_print_hash(value.to_h, truncate, indent+"    ")
      else
        if truncate and value.respond_to? :size
          print "#{indent}#{key} => #{value.size > 50 ? value[0..50]+"..." : value}\n"
        else
          print "#{indent}#{key} => #{value}\n"
        end
      end
    end
    print "#{indent}}\n"
  end

  def self.recursively_print_array(array, truncate=false, indent="")
    print "#{indent}[\n"
    array.each do |item|
      if item.class == Array
        recursively_print_array(item, truncate, indent+"    ")
      elsif item.class == Hash
        recursively_print_hash(item, truncate, indent+"    ")
      elsif item.class < Struct
        recursively_print_hash(item.to_h, truncate, indent+"    ")
      else
        if truncate and item.respond_to? :size
          print "#{indent}#{item.size > 50 ? item[0..50]+"..." : item}\n"
        else
          print "#{indent}#{item}\n"
        end
      end
    end
    print "#{indent}]\n"
  end

  def self.wait_until(timeout, &block)
    begin
      Watir::Wait.until(timeout: timeout, &block)
      return true
    rescue Watir::Wait::TimeoutError => e
      return false
    end
  end

  def self.wait_safely(timeout, &block)

    safety_block = Proc.new {
      begin
        block.call
        true
      rescue
        false
      end
    }

    begin
      Watir::Wait.until(timeout: timeout, &safety_block)
      return true
    rescue Watir::Wait::TimeoutError => e
      return false
    end
  end

end
