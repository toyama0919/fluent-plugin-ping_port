# fluent-plugin-ping_port [![Build Status](https://secure.travis-ci.org/toyama0919/fluent-plugin-ping_port.png?branch=master)](http://travis-ci.org/toyama0919/fluent-plugin-ping_port)

health check with port plugin for fluentd

## Examples
```
<source>
  type ping_port
  tag ping_port.exsample
  host forwarder-host
  port 24224
  timeout 10
  interval 1s
  retry_count 2
</source>

<match ping_port.exsample>
  type stdout
</match>
```

#### output
```
2015-05-13 16:24:05 +0900 ping_port.exsample: {"message":"forwarder-host:24224 Connect Error."}
```

## parameter


## Installation
```
fluent-gem install fluent-plugin-ping_port
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Information

* [Homepage](https://github.com/toyama0919/fluent-plugin-ping_port)
* [Issues](https://github.com/toyama0919/fluent-plugin-ping_port/issues)
* [Documentation](http://rubydoc.info/gems/fluent-plugin-ping_port/frames)
* [Email](mailto:toyama0919@gmail.com)

## Copyright

Copyright (c) 2015 Hiroshi Toyama

