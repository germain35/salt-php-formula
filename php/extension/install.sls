{%- from "php/map.jinja" import php with context %}

include:
  - php.common
  - php.pear

{%- for extension in php.get('extensions', []) %}
  {%- if extension is mapping and extension.provider is defined and extension.provider == 'pecl' %}
    {%- if extension.header_packages is defined %}
php_extension_{{extension.keys()[0]}}_header_packages:
  pkg.installed:
    - pkgs: {{ extension.header_packages }}
    - require_in:
      - pecl: php_extension_{{extension.keys()[0]}}
    {%- endif %}
php_extension_{{extension.keys()[0]}}:
  pecl.installed:
    - name: {{extension.keys()[0]}}
    - require:
      - pkg: php_pear_package
  {%- else %}
php_extension_{{extension}}:
  pkg.installed:
    - name: {{ php.package_prefix ~ extension }}
  {%- endif %}
{%- endfor %}