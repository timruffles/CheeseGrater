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

a = {'y'=>'b',:x => 'b'}
p a.keys_to_symbols