{% from 'newrelic/map.jinja' import newrelic with context %}
{% set p = newrelic.plugin if newrelic.plugin != None else '' %}
{% set s = newrelic.plugin.source if newrelic.plugin.source != None else 'meetme' %}

# MeetMe/newrelic-plugin-agent: https://goo.gl/tlq6t1
{% if (p|count) != 0 and 'meetm' in s %}
    # Required by python-pip
    Install python-setuptools package:
        pkg.latest:
            - pkgs:
                - python-setuptools
            - refresh: True

    Install python-pip package:
        pkg.latest:
            - name: python-pip
            - fromrepo: epel
            - refresh: True

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
{% endif %}

# vim: set bg=dark syntax=yaml paste:
