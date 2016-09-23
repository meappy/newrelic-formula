# New Relic Formula

- Formula to configure New Relic via pillar (see pillar.example)
- Fully functioning New Relic Formula, includes setting up system, application agents and application plugins 

----

## TODO

1. Plugin uses MeetMe's multi-plugin python-based agent. Will include the ability to use New Relic Platform
   Installer (NPI) utility which is java-based.
2. Now that there is a method to locate PHP ini dir, could create templated newrelic.ini file instead of 
   relying on official newrelic-install script
3. Nested dict will need to have defined values, Jinja template will need be structurted to check if variable exists

## Installation

`git clone ...`

## Usage

See pillar.example

## History

TODO: Write history

## Credits

TODO: Write credits

## License

See LICENSE file
