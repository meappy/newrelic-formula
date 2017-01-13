{% from 'newrelic/map.jinja' import newrelic with context %}
# Test for pillar data: https://goo.gl/x3RZhg
{% if salt['pillar.get']('newrelic:plugin') %}
    {% set p = newrelic.plugin %}
    {% set s = newrelic.plugin.source if newrelic.plugin.source != None else 'meetme' %}
    {% for k in s %}
        # MeetMe/newrelic-plugin-agent: https://goo.gl/tlq6t1
        {% if 'meetme' in k %}
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
    
            Configure newrelic-plugin-agent:
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
        # New Relic Platform Installer (NPI) utility: https://goo.gl/Zl0oip
        {% elif 'npi' in k %}
            Download NPI utility:
                cmd.run:
                    - name: 'wget -P /tmp https://download.newrelic.com/npi/release/install-npi-linux-redhat-x64.sh'
                    - env:
                        - http_proxy: 'http://10.69.0.200:8080'
                        - https_proxy: 'http://10.69.0.200:8080'
                    - unless: '[ -f /opt/newrelic-npi/npi ]'
    
            Install NPI utility:
                cmd.run:
                    - name: 'bash /tmp/install-npi-linux-redhat-x64.sh'
                    - env:
                        - http_proxy: 'http://10.69.0.200:8080'
                        - https_proxy: 'http://10.69.0.200:8080'
                        - LICENSE_KEY: {{ newrelic.nrsysmond.license_key }}
                        - PREFIX: '/opt/newrelic-npi' 
                        - UNATTENDED: 'true'
                    - unless: '[ -f /opt/newrelic-npi/npi ]'
    
            Update user group onwership of NPI utility:
                # Can't use file.managed state as can't watch changes
                cmd.run:
                    - name: chown -R root:root /opt/newrelic-npi
                    - onchanges:
                        - cmd: Install NPI utility
    
            Configure NPI utility:
                cmd.run:
                    - name: 'cd /opt/newrelic-npi; ./npi config set proxy_host 10.69.0.200; ./npi config set proxy_port 8080'
                    - onchanges:
                        - cmd: Install NPI utility
    
            {% set plugin = newrelic.plugin.source.npi.type.mysql.plugin %}
            Install NPI plugin:
                # Only does single plugin now
                cmd.run:
                    - name: cd /opt/newrelic-npi; ./npi install {{ plugin }} --yes --noedit --user=root
    
            Prepare NPI plugin:
                file.serialize:
                    - name: /opt/newrelic-npi/plugins/com.newrelic.plugins.mysql.instance/newrelic_mysql_plugin-2.0.0/config/plugin.json
                    - dataset_pillar: newrelic:plugin:source:npi:type:mysql:config
                    - formatter: json
    
            Start NPI plugin:
                cmd.run:
                    - name: cd /opt/newrelic-npi; ./npi stop {{ plugin }}; ./npi start {{ plugin }}
                    - onchanges:
                        - file: Prepare NPI plugin
        {% endif %}
    {% endfor %}
{% endif %}

# vim: set bg=dark syntax=yaml paste:
