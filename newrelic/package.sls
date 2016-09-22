{% from 'newrelic/map.jinja' import newrelic with context -%}
{% set p = newrelic.package if newrelic.package != None else '' -%}

{% if (p|count) != 0 %}
    {% for k in p %}
        Install New Relic {{ k }} package:
            pkg.latest:
                - name: {{ k }}
                - fromrepo: newrelic
                # skip_suggestions doesn't seem to be working
                - skip_suggestions: False
                - refresh: True
    {% endfor -%}
{% endif %}

# vim: set bg=dark syntax=yaml paste:
