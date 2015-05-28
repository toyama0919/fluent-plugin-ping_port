require 'helper'

class PingPortInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf)
    Fluent::Test::InputTestDriver.new(Fluent::PingPortInput).configure(conf)
  end

  def test_configure_full
    d = create_driver %q{
      tag ping_port.exsample
      host web01
      port 24224,80
      timeout 10
      interval 10m
      retry_count 5
    }

    assert_equal 'ping_port.exsample', d.instance.tag
    assert_equal 10 * 60, d.instance.interval
    assert_equal 10, d.instance.timeout
    assert_equal ["24224", "80"], d.instance.instance_variable_get(:@ports)
    assert_equal ({"24224" => 0, "80" => 0}), d.instance.instance_variable_get(:@state)
  end

  def test_configure_error_when_config_is_empty
    assert_raise(Fluent::ConfigError) do
      create_driver  %q{
        tag ping_port.exsample
        host web01
        timeout 10
        interval 10m
        retry_count 5
      }
    end
  end

  def test_emit
    d = create_driver %q{
      tag ping_port.exsample
      host localhost
      port 9999
      timeout 10
      interval 1s
      retry_count 2
    }

    d.run do
      sleep 3
      emits = d.emits
      assert_equal true, emits.length > 0
      assert_equal "ping_port.exsample", emits[0].first
      assert_equal ({"message"=>"localhost:9999 Connect Error."}), emits[0].last
    end
  end
end
