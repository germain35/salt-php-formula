{%- from "php/map.jinja" import php with context %}

include:
  - php.common
  - php.dev
  - php.pear
  {%- if php.fpm_enabled %}
  - php.fpm.service
  {%- endif %}

{%- for extension in php.get('extensions', []) %}
  {%- if extension is mapping and extension.provider is defined and extension.provider == 'pecl' %}
    {%- if extension.header_packages is defined %}

php_extension_{{extension.name}}_header_packages:
  pkg.installed:
    - pkgs: {{ extension.header_packages }}
    - require_in:
      - pecl: php_extension_{{extension.name}}

    {%- endif %}

{%- if salt['file.file_exists'](extension.name) %}
php_extension_{{extension.name}}:
  cmd.run:
    - name: printf "\n" | pecl install --offline --force {{extension.name}}
    - require_in:
      - file: php_extension_{{extension.name}}_ini_file
    - require:
      - pkg: php_pear_package
{%- else %}
php_extension_{{extension.name}}:
  pecl.installed:
    - name: {{extension.name}}
    {%- if extension.version is defined %}
    - version: {{extension.version}}
    {%- endif %}
    {%- if extension.defaults is defined %}
    - defaults: {{extension.defaults}}
    {%- endif %}
    {%- if extension.force is defined %}
    - force: {{extension.force}}
    {%- endif %}
    - require_in:
      - file: php_extension_{{extension.name}}_ini_file
    - require:
      - pkg: php_pear_package
{%- endif %}

php_extension_{{extension.name}}_ini_file:
  file.prepend:
    - name: {{ php.conf_root_ini | path_join(extension.name ~ '.ini') }}
    - text:
      - extension={{extension.name}}.so

    {%- if php.fpm_enabled %}

php_extension_{{extension.name}}_cgi_enable:
  cmd.run:
    - name: {{ php.ext_tool_enable }} -s cgi {{ extension.name }}
    - require:
      - file: php_extension_{{extension.name}}_ini_file

php_extension_{{extension.name}}_fpm_enable:
  cmd.run:
    - name: {{ php.ext_tool_enable }} -s fpm {{ extension.name }}
    - watch_in:
      - service: php_fpm_service
    - require:
      - file: php_extension_{{extension.name}}_ini_file

    {%- endif %}

    {%- if php.cli_enabled %}

php_extension_{{extension.name}}_cli_enable:
  cmd.run:
    - name: {{ php.ext_tool_enable }} -s cli {{ extension.name }}
    - require:
      - file: php_extension_{{extension.name}}_ini_file

    {%- endif %}
  {%- else %}

php_extension_{{extension.name}}:
  pkg.installed:
    - name: {{ php.package_prefix ~ extension.name }}

  {%- endif %}
{%- endfor %}