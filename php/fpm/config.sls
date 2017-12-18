{%- from "php/map.jinja" import php with context %}

include:
  - php.fpm
  - php.fpm.service


{%- if php.fpm is defined and php.fpm.conf is defined %}
php_fpm_conf_file:
  ini.options_present:
    - name: {{ php.fpm_conf_file }}
    - sections: {{ php.fpm.conf }}
    - require:
      - pkg: php_fpm_package
    - watch_in:
      - service: php_fpm_service
{%- endif %}

{%- if php.ini is defined %}
php_fpm_ini_file:
  ini.options_present:
    - name: {{ php.fpm_ini_file }}
    - sections: {{ php.ini }}
    - require:
      - pkg: php_fpm_package
    - watch_in:
      - service: php_fpm_service
{%- endif %}
