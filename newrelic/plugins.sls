{% set p = salt['pillar.get']('newrelic:plugins') %}

{% if (p|count) != 0 %}
newrelic_plugins:
    {% for k,v in p.items() %}
        pkg.installed:
            - name: {{ k }}
    {% endfor %}
{% endif %}

# vim: set bg=dark syntax=yaml paste:
