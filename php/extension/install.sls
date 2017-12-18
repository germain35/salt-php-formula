{%- from "php/map.jinja" import php with context %}

include:
  - php.common
  - php.pear

{%- for extension in php.extensions %}
  {%- if extension is mapping and extension.provider is defined and extension.provider == 'pecl' %}
php_{{extension.keys()[0]}}_extension:
  pecl.installed:
    - name: {{extension.keys()[0]}}
    - require:
      - pkg: php_pear_package
  {%- else %}
php_{{extension}}_extension:
  pkg.installed:
    - name: {{ php.package_prefix ~ extension }}
  {%- endif %}
{%- endfor %}