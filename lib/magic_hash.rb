module MagicHash

  def self.new
    Hash.new.extend(MagicHash)
  end

  def objectify
    tmp = MagicHash.new
    self.each_pair do |key, value|
      new_key = key.is_a?(Symbol) ? key : key.gsub(/\s|-/,"_").strip.to_sym
      if(value.is_a? Hash)
        value.extend(MagicHash) unless value.respond_to? :objectify
        tmp[new_key] = value.objectify
      elsif(value.is_a? Array)
        tmp[new_key] = value.map do |val|
          if val.is_a?(Hash)
            val.extend(MagicHash) unless val.respond_to? :objectify
            val.objectify
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
