require 'yaml'
require 'json'
require 'magic_hash'

class Configulations
  attr_accessor :properties
  attr_accessor :supported_extensions
  attr_accessor :root

  def initialize(root="./config")
    @root = File.expand_path(root)
    @supported_extensions = [:yml, :json, :yaml, :js]
    find_properties("#{@root}/*") unless @properties
  end

  def self.configure(&blk)
    me = Configulations.new
    blk.call(me)
    me.find_properties("#{@root}/*")
    me
  end

  def find_properties(starting_dir)
    @properties = MagicHash.new

    Dir[starting_dir].each do |file|
      if File.directory?(file)
        base = File.basename(file)
        unless @properties[base]
          @properties[base] = Configulations.new(file)
        end
      elsif(supported_extensions.include?(File.extname(file)[1..-1].to_sym))
        ext = File.extname(file)
        base = File.basename(file, ext)
        parser = parser_for_extname(ext)
        data = parser.send(:load, File.read(file))
        @properties[base]= parser.send(:load, File.read(file))
      end
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
