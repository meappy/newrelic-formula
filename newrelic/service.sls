{% from 'newrelic/map.jinja' import newrelic with context %}

newrelic_service:
    service.{{ newrelic.service.state }}:
        - name:     {{ newrelic.service.name    }}
        - enable:   {{ newrelic.service.enable  }}
