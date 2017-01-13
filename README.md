# New Relic Formula

- Formula to configure New Relic via pillar (see pillar.example)
- Almost fully functioning New Relic Formula, includes setting up system, application agents and application plugins
- Tested on RHEL/CentOS 6.x and 7.x, other variants may not get positive results

----

## TODO

1. Plugin uses MeetMe's multi-plugin python-based agent, also includes the ability to use New Relic Platform
   Installer (NPI) utility which is java-based.
2. For NPI-based plugins, only installs MySQL plugin
2. Now that there is a method to locate PHP ini dir, could create templated newrelic.ini file instead of 
   relying on official newrelic-install script
3. Nested dict will need to have defined values, Jinja template will need be structurted to check if variable exists

## Installation

`git clone 

## Usage

Check pillar.example for example

## History

### 20170113
1. Added support for NPI 

## Credits

## License

See LICENSE file
