require 'yaml'
require 'json'
require 'magic_hash'

class Configulations
  attr_accessor :root
  attr_accessor :properties
  attr_accessor :supported_extensions
  attr_accessor :environments

  def initialize(root="./config")
    @root                 = File.expand_path(root)
    @supported_extensions = [:yml, :yaml, :js, :json]
    @environments         = ["RAILS_ENV", "RACK_ENV", "APP_ENV"]
    @properties           = MagicHash.new
    find_properties(config_files_at_dir(@root))
    @properties.objectify
  end

  def environmental_override?(base)
    !@environments.select{|ev| base.downcase == (ENV[ev] || "").downcase}.empty?
  end

  def find_properties(config_files, props=@properties, parent=nil)
    return if config_files.empty?
    file        = config_files.shift
    ext         = File.extname(file)
    base        = File.basename(file, ext)
    parser      = parser_for_extname(ext)
    config_data = parser.send(:load, File.read(file))

    if parent
      props.merge!(config_data) if environmental_override?(base)
      props[parent] = config_data if props[parent]
    end

    props[base] = config_data

    dir = "#{File.dirname(file)}/#{base}"
    if File.exists?(dir) and File.directory?(dir)
      child_configs = glob_directory_against_supported_extensions(dir)
      find_properties(child_configs, props[base], base)
    end

    find_properties(config_files, props, parent)
  end

  def glob_directory_against_supported_extensions(dir)
    Dir.glob("#{dir}/*.{#{ext_glob_string}}")
  end

  def ext_glob_string
    supported_extensions.map{|x|x.to_s}.join(",")
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

  def config_files_at_dir(dir)
    ( config_files = glob_directory_against_supported_extensions(dir.to_s) ).reject do |file|
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
