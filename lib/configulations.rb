require 'yaml'
require 'json'
require 'magic_hash'

class Configulations
  attr_accessor :properties
  attr_accessor :include_pattern

  def initialize
    @include_pattern = File.expand_path(".") << "/config/**/*.{yml,json}"
    find_properties
  end

  def self.configure(&blk)
    me = Configulations.new
    blk.call(me)
    me.find_properties
    me
  end

  def find_properties
    @properties = MagicHash.new

    Dir[@include_pattern].each do |file|
      ext = File.extname(file)
      base = File.basename(file, ext)
      parser = parser_for_extname(ext)
      @properties[base]= parser.send(:load, File.read(file))
    end

    @properties.objectify
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
