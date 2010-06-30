class Object
  def deep_clone
    YAML::load(YAML::dump(self))
  end
  alias :deep_dup :deep_clone
end

class Hash
  # merge recursively, merging not overriding hash fields
  def deep_merge with_hash
    merger = lambda do |key, val1, val2|
      Hash === val1 && Hash === val2 ? val1.merge(val2,&merger) : val2
    end
    merge(with_hash,&merger)
  end
  # helper class to normalize config from yaml
  def keys_to_symbols recursive = true
    each_pair do |key,val|
      
      if recursive && (val.class.equal? Hash)
        val = val.keys_to_symbols
      end
      next if Symbol === key
      
      self.delete(key)
      self[key.to_sym] = val
    end
  end
end

class Module
    
  def define_exception the_class, default_message = nil, type = RuntimeError
    exception = Class.new(type) do
      @@default_message = default_message
      def self.new msg = nil
        super msg || @@default_message
      end
    end
    const_set(the_class.to_s, exception)
  end
    
end

class String
  
  # joins two strings with a joiner, not adding a joiner if present on either end of the join
  def join_with joiner, string
    joiner = Regexp.quote(joiner)
    self_ret = self.dup.gsub(Regexp.new("#{joiner}*$"),'')
    
    self_ret == '' || string == '' ? 
      self + string : 
      self_ret + joiner + string.gsub(Regexp.new("^#{joiner}*"),'')
  end
  
end