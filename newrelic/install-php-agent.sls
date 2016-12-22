{% from 'newrelic/map.jinja' import newrelic with context %}
# Test for pillar data: https://goo.gl/x3RZhg
{% if salt['pillar.get']('newrelic:package') %}

    {% set p = newrelic.package if newrelic.package != None else '' %}
    {% set s = 'newrelic-php' %}
    {% set php_inidir = salt['cmd.shell']('echo "<?php print PHP_CONFIG_FILE_SCAN_DIR; ?>" | 
        $(rpm -ql $(rpm -qa *php*cli*) | grep "bin/php\$") -n -d display_errors=Off -d display_startup_errors=Off -d error_reporting=0 -q 2> /dev/null') %}
    {% set nr_inifile = php_inidir ~ '/newrelic.ini' %}
    
    {% if (p|count) != 0 %}
        {% for i in p %}
            {% if s in i %}
                Run /usr/bin/newrelic-install install:
                    cmd.run:
                        - name: /usr/bin/newrelic-install install
                        - onlyif: which newrelic-install
                        - env:
                            - NR_INSTALL_SILENT: '1'
                            - NR_INSTALL_KEY: {{ newrelic.nrsysmond.license_key }}
                        - onchanges:
                            - pkg: {{ i }}
    
                {% for key in p.keys() -%}
                     {% for key,value in p[key].items() -%}
                          Configure PHP agent {{ key }} value:
                              ini.options_present:
                                  - name: {{ nr_inifile }} 
                                  - sections:
                                      newrelic:
                                          {{ key }}: {{ value }}
                     {% endfor -%}
                {% endfor %}
    
            {% endif %}
        {% endfor %}
    {% endif %}

{% endif %}

# vim: set bg=dark syntax=yaml paste:
