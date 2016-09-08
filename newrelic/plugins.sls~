{% set p = salt['pillar.get']('newrelic:plugins') %}

{% if (p|count) != 0 %}
newrelic_plugins:
    {% for k,v in p.items() %}
        pkg.{{ v }}:
            - name: {{ k }}
    {% endfor %}
{% endif %}
