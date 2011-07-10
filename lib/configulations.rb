require 'yaml'
require 'json'
require 'magic_hash'

class Configulations

  attr_accessor :properties, :include_pattern

  def initialize
    @include_pattern = File.expand_path(".") << "/config/**/*.{yml,json}"
    @properties = MagicHash.new
    find_properties(top_level_config_files)
    @properties.objectify
  end

  def self.configure(&blk)
    me = Configulations.new
    me.properties.clear
    blk.call(me)
    me.find_properties(me.top_level_config_files)
    me.properties.objectify
    me
  end

  def find_properties(config_files, props=@properties, parent=nil)
    unless config_files.empty?
      file        = config_files.shift
      ext         = File.extname(file)
      base        = File.basename(file, ext)
      parser      = parser_for_extname(ext)
      config_data = parser.send(:load, File.read(file))

      if parent
        config_data.each_key do |key|
          props[key] = config_data.delete(key) if props[key]
        end
      end

      props[base] = config_data

      if Dir.exists?(dir = "#{File.dirname(file)}/#{base}")
        child_configs = Dir.glob("#{dir}/*.{yml,json}")
        find_properties(child_configs, props[base], base)
      end

      find_properties(config_files, props)
    end
  end

  def parser_for_extname(extname)
    case extname
    when /\.js(?:on)?/i
      return JSON
    when /\.ya?ml/i
      return YAML
    else
      raise "Only files ending in .js, .json, .yml, .yaml have parsers at the moment."
    end
  end

  def top_level_config_files
    (config_files = Dir.glob(include_pattern)).reject do |file|
      ext  = File.extname(file)
      base = File.basename(file, ext)
      parent_config = file.gsub(/\/#{base}#{ext}/, ext)
      config_files.include?(parent_config)
    end
  end

  def method_missing(message_name, *message_arguments, &optional_block)
    message = message_name.to_s.strip.gsub(/-/,"_")
    if message =~ /=/
      @properties[message.gsub(/=/,"").to_sym] = message_arguments.flatten.first
      return
    elsif message =~ /\?/
      return !!(@properties[message.gsub(/\?/,"").to_sym])
    else
      return @properties[message.to_sym] if @properties.has_key? message.to_sym
    end

    super message_name, *message_arguments, &optional_block
  end

end
