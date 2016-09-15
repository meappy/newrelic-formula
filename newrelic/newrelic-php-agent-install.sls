#set NR_INSTALL_SILENT environment variable:
#    environ.setenv:
#        - name: NR_INSTALL_SILENT
#        - value: '1'
#
#set NR_INSTALL_KEY environment variable:
#    environ.setenv:
#        - name: NR_INSTALL_KEY
#        - value: {{ salt.pillar.get('newrelic:nrsysmond:license_key', 'REPLACE_WITH_REAL_KEY') }}

/usr/bin/newrelic-install install:
    cmd.run:
        - onlyif: which newrelic-install
        - env:
            - NR_INSTALL_SILENT: '1'
            - NR_INSTALL_KEY: {{ salt.pillar.get('newrelic:nrsysmond:license_key', 'REPLACE_WITH_REAL_KEY') }}
#        - onchanges:
#            - pkg: newrelic-php5

# vim: set bg=dark syntax=yaml paste:
