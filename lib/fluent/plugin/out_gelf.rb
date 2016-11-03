module Fluent

class GELFOutput < BufferedOutput

  Plugin.register_output("gelf", self)

  require_relative 'gelf_util'
  include GelfUtil

  config_param :use_record_host, :bool, :default => false
  config_param :add_msec_time, :bool, :default => false
  config_param :host, :string, :default => nil
  config_param :port, :integer, :default => 12201
  config_param :protocol, :string, :default => 'tcp'

  def initialize
    super
    require "gelf"
  end

  def configure(conf)
    super

    # a destination hostname or IP address must be provided
    raise ConfigError, "'host' parameter (hostname or address of Graylog2 server) is required" unless conf.has_key?('host')

    # choose protocol to pass to gelf-rb Notifier constructor
    # (@protocol is used instead of conf['protocol'] to leverage config_param default)
    if @protocol == 'udp' then @proto = GELF::Protocol::UDP
    elsif @protocol == 'tcp' then @proto = GELF::Protocol::TCP
    else raise ConfigError, "'protocol' parameter should be either 'udp' or 'tcp' (default)"
    end
  end

  def start
    super

    @conn = GELF::Notifier.new(@host, @port, 'WAN', {:facility => 'fluentd', :protocol => @proto})

    # Errors are not coming from Ruby so we use direct mapping
    @conn.level_mapping = 'direct'
    # file and line from Ruby are in this class, not relevant
    @conn.collect_file_and_line = false
  end

  def shutdown
    super
  end

  def format(tag, time, record)

    make_gelfentry(
      tag,time,record,
      {
        :use_record_host => @use_record_host,
        :add_msec_time => @add_msec_time
      }
    ).to_msgpack

  end

  def write(chunk)
    chunk.msgpack_each do |data|
      @conn.notify!(data)
    end
  end

end


end

# vim: sw=2 ts=2 et
