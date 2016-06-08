{% from 'newrelic/map.jinja' import newrelic with context %}

newrelic_install:
    pkg.installed:
        - name: {{ newrelic.install.name }}
