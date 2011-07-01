require 'yaml'
require 'json'
require 'magic_hash'

class Configulations
  attr_accessor :properties

  def initialize
    @properties = {}
    @properties.extend(MagicHash)

    find_yaml_properties
    find_json_properties

    @properties.objectify
    yield self if block_given?
    self
  end

  def find_json_properties
    Dir[File.expand_path(".") << "/config/**/*.json"].each do |json_file|
      @properties[File.basename(json_file, ".json")] = JSON.load(File.read(json_file))
    end
  end

  def find_yaml_properties
    Dir[File.expand_path(".") << "/config/**/*.yml"].each do |yaml_file|
      @properties[File.basename(yaml_file, ".yml")] = YAML.load(File.read(yaml_file))
    end
  end

  def method_missing(message_name, *message_arguments, &optional_block)
    result = properties.send message_name.to_sym, *message_arguments
    return result if result
    message = message_name.to_s.strip.gsub(/-/,"_")
    if message.to_s =~ /=/
      properties[message.gsub(/=/,"").to_sym] = message_arguments.flatten.first
      return
    end
    super message_name, *message_arguments, &optional_block
  end
end
