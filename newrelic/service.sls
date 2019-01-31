{% from 'newrelic/map.jinja' import newrelic with context %}

{% if salt['pillar.get']('newrelic:infra') %}
newrelic_service:
    service.{{ newrelic.service.state }}:
        - name:     {{ newrelic.service.name|replace("sysmond", "infra") }}
        - enable:   {{ newrelic.service.enable  }}
        - reload:   {{ newrelic.service.reload  }}
        # Reusing some variables, ideally needs to be newrelic.service
        - onchanges:
            - pkg:  {{ newrelic.install.name|replace("sysmond", "infra") }}
            - file: {{ newrelic.infra.name }}

{% else %}

{% if salt['pillar.get']('newrelic:nrsysmond') %}
newrelic_service:
    service.{{ newrelic.service.state }}:
        - name:     {{ newrelic.service.name    }}
        - enable:   {{ newrelic.service.enable  }}
        - reload:   {{ newrelic.service.reload  }}
        # Reusing some variables, ideally needs to be newrelic.service
        - onchanges:
            - pkg:  {{ newrelic.install.name    }}
            - file: {{ newrelic.nrsysmond.name  }}
{% endif %}

{% endif %}

# vim: set bg=dark syntax=yaml paste:
