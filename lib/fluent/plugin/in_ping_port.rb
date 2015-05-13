module Fluent
  class PingPortInput < Fluent::Input
    Plugin.register_input 'ping_port', self

    config_param :tag, :string
    config_param :host, :string
    config_param :port, :string
    config_param :timeout, :integer, default: 1
    config_param :interval, :time, default: '5m'

    def configure(conf)
      require 'socket'
      require 'timeout'
      super
    end

    def start
      @ports = @port.split(',')
      @thread = Thread.new(&method(:run))
    end

    def shutdown
      Thread.kill(@thread)
    end

    def run
      loop do
        Thread.new(&method(:emit_ping_port))
        sleep @interval
      end
    end

    def emit_ping_port
      begin
        @ports.each do |port|
          unless is_port_open?(@host, port, @timeout)
            record = {
              'message' => "#{@host}:#{port} Connect Error." 
            }
            Fluent::Engine.emit @tag, Fluent::Engine.now, record
          end
        end
      rescue => e
        log.error e
      end
    end

    private

    def is_port_open?(host, port, timeout)
      begin
        Timeout::timeout(timeout) do
          begin
            s = TCPSocket.new(host, port)
            s.close
            return true
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            return false
          end
        end
      rescue Timeout::Error
      end
      return false
    end    
  end
end
