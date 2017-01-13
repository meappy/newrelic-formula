{% from 'newrelic/map.jinja' import newrelic with context %}

{% if salt['pillar.get']('newrelic:nrsysmond') %}
newrelic_nrsysmond:
        file.managed:
            - name:     {{ newrelic.nrsysmond.name     }}
            - source:   {{ newrelic.nrsysmond.source   }}
            - template: {{ newrelic.nrsysmond.template }}
{% endif %}

# vim: set bg=dark syntax=yaml paste:
