require_relative '../../ruby_task_helper/files/task_helper.rb'
require_relative '../../ruby_plugin_helper/lib/plugin_helper.rb'
require 'json'
require 'diplomat'

class ConsulInventory < TaskHelper
  include RubyPluginHelper

  attr_reader :gateway

  def config_client(opts)
    return @client if @client

    if opts.key?(:bastion_host) || opts.key?(:bastion_user)
      if !(opts.key?(:bastion_host) && opts.key?(:bastion_user))
        msg = 'Both bastion_host and bastion_user need to be specified when using a bastion_host'
        raise TaskHelper::Error.new(msg, 'bolt-plugin/validation-error')
      end

      require 'net/ssh/gateway'
      @gateway = Net::SSH::Gateway.new(opts[:bastion_host], opts[:bastion_user], opts.fetch(:bastion_ssh_options, {}))
      gateway.open('127.0.0.1', opts[:port], opts[:port])
    end

    Diplomat.configure do |config|
      config.url = "http://#{opts[:host]}:#{opts[:port]}"
    end
  end

  def resolve_reference(opts)
    config_client(opts)
    nodes = Diplomat::Node.get_all.map do |node|
      opts[:use_hostname] ? node['Node'] : node['Address']
    end
    gateway.shutdown!
    nodes
  end

  def task(opts = {})
    { value: resolve_reference(opts) }
  end
end

ConsulInventory.run if $PROGRAM_NAME == __FILE__
