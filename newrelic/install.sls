{% from 'newrelic/map.jinja' import newrelic with context %}

newrelic_install:
    pkg.latest:
        - name: {{ newrelic.install.name }}
        - fromrepo: newrelic
        - skip_suggestions: False
        - refresh: True

# vim: set bg=dark syntax=yaml paste:
