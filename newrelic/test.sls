{% from 'newrelic/map.jinja' import newrelic with context %}
{% set p = newrelic.package if newrelic.package != None else '' %}
{% set s = 'newrelic-php' %}
{% set php_inidir = salt['cmd.shell']('echo "<?php print PHP_CONFIG_FILE_SCAN_DIR; ?>" |
    php -n -d display_errors=Off -d display_startup_errors=Off -d error_reporting=0 -q 2> /dev/null') %}
{% set nr_inifile = php_inidir ~ '/newrelic.ini' %}

#{{ nr_inifile }}:
#    ini.options_present:
#        - sections:
#            newrelic:
#                newrelic.appname: '"testval"'

{% for key in p.keys() -%}
    {% if key in p.keys() -%}
        {% for key,value in p[key].items() -%}
            {% if key,value in p[key].items() -%}
                Configure PHP agent {{ key }} value:
                    ini.options_present:
                        - name: {{ nr_inifile }}
                        - sections:
                            newrelic:
                                {{ key }}: "{{ value }}"
            {% endif -%}
        {% endfor -%}
    {% endif %}
{% endfor %}

# vim: set bg=dark syntax=yaml paste:
