# Port Scanner - super simple

This is a super simple port scanner. The original script can be found at [Ruby Guides: How to write a Port Scanner in Ruby](https://rubyguides.com/2016/11/port-scanner-in-ruby)

## Usage

### Simple run:

    $ ./port_scanner [DOMAIN_NAME]

### With a configuration file:

    $ ./port_scanner -c [CONFIGURATION_FILE_JSON]

### Configuration file syntax:

The configuration file needs to be a valid JSON file.

    {
      "domain_name": "www.example.com",
      "ports": [21,22,23,25,53,80,443,3306,5601,8080]
      "timeout": 2
    }

## License

Apache License, Version 2.0 https://www.apache.org/licenses/LICENSE-2.0.html
