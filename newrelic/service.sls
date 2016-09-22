{% from 'newrelic/map.jinja' import newrelic with context %}

newrelic_service:
    service.{{ newrelic.service.state }}:
        - name:     {{ newrelic.service.name    }}
        - enable:   {{ newrelic.service.enable  }}
        - reload:   {{ newrelic.service.reload  }}
        # Reusing some variables, ideally needs to be newrelic.service
        - onchanges:
            - pkg:  {{ newrelic.install.name    }}
            - file: {{ newrelic.nrsysmond.name  }}

# vim: set bg=dark syntax=yaml paste:
