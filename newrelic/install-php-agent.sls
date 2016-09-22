{% from 'newrelic/map.jinja' import newrelic with context %}
{% if newrelic.packages.newrelic-php == true %}
/usr/bin/newrelic-install install:
    cmd.run:
        - onlyif: which newrelic-install
        - env:
            - NR_INSTALL_SILENT: '1'
            - NR_INSTALL_KEY: {{ newrelic.nrsysmond.license_key }}
        - onchanges:
            - pkg: newrelic-php
{% endif %}

# vim: set bg=dark syntax=yaml paste:
