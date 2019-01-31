{% from 'newrelic/map.jinja' import newrelic with context %}

{% if salt['pillar.get']('newrelic:infra') %}
newrelic_install_infra:
    pkg.latest:
        - name: {{ newrelic.install.name|replace("sysmond", "infra") }}
        - fromrepo: newrelic-infra
        - skip_suggestions: False
        - refresh: True

{% else %}

{% if salt['pillar.get']('newrelic:nrsysmond') %}
newrelic_install_sysmond:
    pkg.latest:
        - name: {{ newrelic.install.name }}
        - fromrepo: newrelic
        - skip_suggestions: False
        - refresh: True
{% endif %}

{% endif %}

# vim: set bg=dark syntax=yaml paste:
