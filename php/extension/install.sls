{%- from "php/map.jinja" import php with context %}

include:
  - php.common
  - php.pear

{%- for extension in php.get('extensions', []) %}
  {%- if extension is mapping and extension.provider is defined and extension.provider == 'pecl' %}
    {%- if extension.header_packages is defined %}
php_extension_{{extension.name}}_header_packages:
  pkg.installed:
    - pkgs: {{ extension.header_packages }}
    - require_in:
      - pecl: php_extension_{{extension.name}}
    {%- endif %}
php_extension_{{extension.name}}:
  pecl.installed:
    - name: {{extension.name}}
    - require:
      - pkg: php_pear_package
  {%- else %}
php_extension_{{extension.name}}:
  pkg.installed:
    - name: {{ php.package_prefix ~ extension.name }}
  {%- endif %}
{%- endfor %}