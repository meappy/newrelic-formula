{% from 'newrelic/map.jinja' import newrelic with context %}

{% if salt['pillar.get']('newrelic:nrsysmond') %}
newrelic_install:
    pkg.latest:
        - name: {{ newrelic.install.name }}
        - fromrepo: newrelic
        - skip_suggestions: False
        - refresh: True
{% endif %}

# vim: set bg=dark syntax=yaml paste:
