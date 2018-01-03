{%- from "php/map.jinja" import php with context %}


include:
  - php.common
  {%- if 'pear' in php.packages %}
  - php.pear
  {%- endif %}
  {%- if 'cli' in php.packages %}
  - php.cli
  {%- endif %}
  {%- if 'fpm' in php.packages %}
  - php.fpm
  {%- endif %}
  {%- if php.packages is defined %}
  - php.packages
  {%- endif %}
  {%- if php.extensions is defined %}
  - php.extension
  {%- endif %}