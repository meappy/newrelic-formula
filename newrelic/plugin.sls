{% from 'newrelic/map.jinja' import newrelic with context %}
# Test for pillar data: https://goo.gl/x3RZhg
{% if salt['pillar.get']('newrelic:plugin') %}
    {% set p = newrelic.plugin %}
    {% set s = newrelic.plugin.source if newrelic.plugin.source != None else 'meetme' %}
    {% if (p|count) != 0 %}
        {% for k in s %}
            {% if 'meetme' in k %}
            # MeetMe/newrelic-plugin-agent: https://goo.gl/tlq6t1
                Install python-setuptools package:
                    pkg.latest:
                        - pkgs:
                            - python-setuptools
                        - refresh: True
                        - unless: 'rpm -qa | egrep "python.*setuptools"'

                Install python-pip package:
                    pkg.latest:
                        - name: python-pip
                        - fromrepo: epel
                        - refresh: True
                        - unless: 'rpm -qa | egrep "python.*pip"'

                # https://goo.gl/eU65Ix
                Run wget https://bootstrap.pypa.io/ez_setup.py:
                    cmd.run:
                        - name: wget https://bootstrap.pypa.io/ez_setup.py -O - | python
                        - onlyif: which pip
                        - onchanges:
                            - pkg: python-pip

                # May encounter "Certificate verify failed when uploading to NewRelic #480" issue: https://goo.gl/rXcdXL
                # Check /var/log/newrelic/newrelic-plugin-agent.log
   
                # https://goo.gl/2NcJYs
                Install newrelic-plugin-agent:
                    pip.installed:
                        - name: newrelic-plugin-agent
                        - require:
                            - pkg: python-pip
                        - unless: 'which newrelic-plugin-agent'
   
                /etc/newrelic/newrelic-plugin-agent.cfg:
                    file.managed:
                        - name: /etc/newrelic/newrelic-plugin-agent.cfg
                        - source: salt://newrelic/files/newrelic-plugin-agent.cfg.jinja
                        - user: root
                        - group: newrelic
                        - mode: 640
                        - template: 'jinja'

                {% if grains['os_family'] == 'RedHat' -%}
                /etc/init.d/newrelic-plugin-agent:
                    file.managed:
                        - name: /etc/init.d/newrelic-plugin-agent
                        # This should eventually be a gitfs backend: https://goo.gl/tlq6t1
                        - source: salt://newrelic/files/newrelic-plugin-agent.rhel
                        - user: root
                        - group: root
                        - mode: 755
                        - template: 'jinja'

                Manage newrelic-plugin-agent service:
                    service.running:
                        - name: newrelic-plugin-agent
                        - enable: True
                        # Make sure restart instead of reload as reload option is not available
                        # Usage: /etc/init.d/newrelic-plugin-agent {start|stop|status|restart}
                        - reload: False
                        - onchanges:
                            - file: /etc/newrelic/newrelic-plugin-agent.cfg
                {% endif %}

            {% elif 'npi' in k %}
            # New Relic Platform Installer (NPI) utility: https://goo.gl/Zl0oip
                Install NPI utility:
                    cmd.run:
                        - name: 'echo -e y | bash -c $(curl -x http://10.69.0.200:8080 https://download.newrelic.com/npi/release/install-npi-linux-redhat-x64.sh)'
                        - env:
                            - LICENSE_KEY: {{ newrelic.nrsysmond.license_key }}
                            - PREFIX: '/opt/newrelic-npi' 
                            - UNATTENDED: 'true'
                        - unless: '[ -f /opt/newrelic-npi/npi ]'

                Update user group onwership of NPI utility:
                    cmd.run:
                        - name: chown -R root:root /opt/newrelic-npi
                        - onchanges:
                            - cmd: Install NPI utility
            {% endif %}
        {% endfor %}
    {% endif %}
{% endif %}

# vim: set bg=dark syntax=yaml paste:
