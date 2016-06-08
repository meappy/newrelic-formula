{% from 'newrelic/map.jinja' import newrelic with context %}

newrelic_nrsysmond:
        file.managed:
            - name:     {{ newrelic.nrsysmond.name     }}
            - source:   {{ newrelic.nrsysmond.source   }}
            - template: {{ newrelic.nrsysmond.template }}
