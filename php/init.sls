{%- from "php/map.jinja" import php with context %}


include:
  - php.common
  {%- if php.packages is defined %}
  - php.packages
  {%- endif %}
  {%- if php.dev_enabled %}
  - php.dev
  {%- endif %}
  {%- if php.pear_enabled %}
  - php.pear
  {%- endif %}
  {%- if php.cli_enabled %}
  - php.cli
  {%- endif %}
  {%- if php.fpm_enabled %}
  - php.fpm
  {%- endif %}
  {%- if php.extensions is defined %}
  - php.extension
  {%- endif %}