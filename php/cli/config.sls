{%- from "php/map.jinja" import php with context %}

include:
  - php.cli

{%- if php.ini is defined %}
php_cli_ini_file:
  ini.options_present:
    - name: {{ php.cli_ini_file }}
    - sections: {{ php.ini }}
    - require:
      - pkg: php_cli_package
{%- endif %}
