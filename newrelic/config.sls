{% from 'newrelic/map.jinja' import newrelic with context %}

{% if salt['pillar.get']('newrelic:infra') %}
newrelic_infra:
        file.managed:
            - name:     {{ newrelic.infra.name     }}
            - source:   {{ newrelic.infra.source   }}
            - template: {{ newrelic.infra.template }}

{% else %}

{% if salt['pillar.get']('newrelic:nrsysmond') %}
newrelic_nrsysmond:
        file.managed:
            - name:     {{ newrelic.nrsysmond.name     }}
            - source:   {{ newrelic.nrsysmond.source   }}
            - template: {{ newrelic.nrsysmond.template }}
{% endif %}

{% endif %}

# vim: set bg=dark syntax=yaml paste:
