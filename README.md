# Fluentd GELF output and formatter plugins
This is a fork of the fluent-plugin-gelf (https://github.com/emsearcy/fluent-plugin-gelf) created in order to publish a gem with the changes contained in pull request #34.  The original pull request #34 will not be used, due to some problems discovered, and will be replaced by three smaller PRs which will implement the same change set, albeit in smaller chunks.

## Overview
Fluentd GELF output and formatter plugins.

## Installation
```bash
gem install fluent-plugin-gelf-hs
```

## Output plugin configuration
```
<match **>
  type gelf
  host <remote GELF host>
  port <remote GELF port>
  protocol <tcp or udp (default)>
  [ fluent buffered output plugin configuration ]
</match>
```

## Formatter plugin configuration
```
<match **>
  type file (any type that that takes a format argument)
  format gelf
  [ fluent file output plugin configuration ]
</match>
```
