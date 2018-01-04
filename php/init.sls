{%- from "php/map.jinja" import php with context %}


include:
  - php.common
  {%- if php.pear_enabled %}
  - php.pear
  {%- endif %}
  {%- if php.cli_enabled %}
  - php.cli
  {%- endif %}
  {%- if php.fpm_enabled %}
  - php.fpm
  {%- endif %}
  {%- if php.packages is defined %}
  - php.packages
  {%- endif %}
  {%- if php.extensions is defined %}
  - php.extension
  {%- endif %}