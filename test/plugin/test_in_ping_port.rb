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
      tag test
      interval 10m
    }

    assert_equal 'test', d.instance.tag
    assert_equal 10 * 60, d.instance.interval
  end

  def test_configure_error_when_config_is_empty
    assert_raise(Fluent::ConfigError) do
      create_driver ''
    end
  end
end