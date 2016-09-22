{% from 'newrelic/map.jinja' import newrelic with context %}

{% if grains['os_family'] == 'RedHat' -%}
Configure New Relic repo:
    pkgrepo.managed:
        {% for k,v in newrelic.repo.items() -%}
            - {{ k }}: {{ v }}
        {% endfor %}
Configure EPEL repo:
    pkgrepo.managed:
        {% for k,v in newrelic.epel.items() -%}
            - {{ k }}: {{ v }}
        {% endfor %}
{% endif %}

# vim: set bg=dark syntax=yaml paste:
