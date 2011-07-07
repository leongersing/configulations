module MagicHash

  def self.new
    Hash.new.extend(MagicHash)
  end

  def objectify
    self.make_keys_valid_message_aliases
    self.hash_all_keys
    self
  end

  def make_keys_valid_message_aliases
    tmp = MagicHash.new
    self.each_pair do |key, value|
      new_key = key.is_a?(Symbol) ? key : key.gsub(/\s|-/,"_").strip.to_sym
      if(value.is_a? Hash)
        value.extend(MagicHash) unless value.respond_to? :objectify
        tmp[new_key] = value.make_keys_valid_message_aliases
      elsif(value.is_a? Array)
        tmp[new_key] = value.map do |val|
          if val.is_a?(Hash)
            val.extend(MagicHash) unless val.respond_to? :objectify
            val.make_keys_valid_message_aliases
          else
            val
          end
        end
      else
        tmp[new_key] = value
      end
    end
    self.replace(tmp)
  end

  def hash_all_keys
    tmp = MagicHash.new
    self.each_pair do |k, v|
      if v.is_a? Hash
        v.extend(MagicHash) unless v.respond_to? :objectify
        tmp[k.to_sym]= v.hash_all_keys
      elsif v.is_a? Array
        v = v.map do |value|
          if value.is_a?(Hash.class)
            value.extend(MagicHash) unless value.respond_to? :objectify
            value.hash_all_keys
          else
            value
          end
        end
        tmp[k.to_sym]= v
      else
        tmp[k.to_sym]= v
      end
    end
    self.replace(tmp)
  end

  def method_missing(method_name, *args, &blk)
    message = method_name.to_s.strip.downcase.gsub(/-/,"_")
    if message =~ /=/
      self[message.gsub(/=/,"").to_sym]= args.flatten.first
      self.objectify
      return
    elsif message =~ /\?/
      return !!(self[message.gsub(/\?/,"").to_sym])
    else
      result = self[message.to_sym]
      return result if result
    end

    super(method_name, *args, &blk)
  end
end
