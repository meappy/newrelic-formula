{% from 'newrelic/map.jinja' import newrelic with context %}

newrelic_official_repo:
    pkgrepo.managed:
        {% for k,v in newrelic.repo.items() %}
            - {{ k }}: {{ v }}
        {% endfor %}
