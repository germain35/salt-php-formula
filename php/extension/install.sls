{%- from "php/map.jinja" import php with context %}

include:
  - php.common
  - php.dev
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
php_extension_{{extension.name}}_ini_file:
  file.prepend:
    - name: {{ php.conf_root_ini | path_join(extension.name ~ '.ini') }}
    - text:
      - extension={{extension.name}}.so
    - require:
      - pecl: php_extension_{{extension.name}}
  {%- else %}
php_extension_{{extension.name}}:
  pkg.installed:
    - name: {{ php.package_prefix ~ extension.name }}
  {%- endif %}
{%- endfor %}