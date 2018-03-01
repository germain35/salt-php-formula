{%- from "php/map.jinja" import php with context %}

include:
  - php.common
  - php.dev
  - php.pear
  {%- if php.fpm_enabled %}
  - php.fpm.service
  {%- endif %}

{%- for extension, params in php.get('extensions', {}).iteritems() %}
  {%- if params.provider == 'pecl' %}
    {%- if params.header_packages is defined %}

php_extension_{{extension}}_header_packages:
  pkg.installed:
    - pkgs: {{ params.header_packages }}
    - require_in:
      - pecl: php_extension_{{extension}}

    {%- endif %}

    {%- if params.source is defined and salt['file.file_exists'](params.source) %}
php_extension_{{extension}}:
  cmd.run:
    - name: printf "\n" | pecl install --offline --force {{params.source}}
    - require_in:
      - file: php_extension_{{extension}}_ini_file
    - require:
      - pkg: php_pear_package
    {%- else %}
php_extension_{{extension}}:
  pecl.installed:
    - name: {{extension}}
    {%- if params.version is defined %}
    - version: {{params.version}}
    {%- endif %}
    {%- if params.defaults is defined %}
    - defaults: {{params.defaults}}
    {%- endif %}
    {%- if params.force is defined %}
    - force: {{params.force}}
    {%- endif %}
    - require_in:
      - file: php_extension_{{extension}}_ini_file
    - require:
      - pkg: php_pear_package
    {%- endif %}

php_extension_{{extension}}_ini_file:
  file.prepend:
    - name: {{ php.conf_root_ini | path_join(extension ~ '.ini') }}
    - text:
      - extension={{extension}}.so

    {%- if php.fpm_enabled %}

php_extension_{{extension}}_cgi_enable:
  cmd.run:
    - name: {{ php.ext_tool_enable }} -s cgi {{ extension }}
    - require:
      - file: php_extension_{{extension}}_ini_file

php_extension_{{extension}}_fpm_enable:
  cmd.run:
    - name: {{ php.ext_tool_enable }} -s fpm {{ extension }}
    - watch_in:
      - service: php_fpm_service
    - require:
      - file: php_extension_{{extension}}_ini_file

    {%- endif %}

    {%- if php.cli_enabled %}

php_extension_{{extension}}_cli_enable:
  cmd.run:
    - name: {{ php.ext_tool_enable }} -s cli {{ extension }}
    - require:
      - file: php_extension_{{extension}}_ini_file

    {%- endif %}
  {%- else %}

php_extension_{{extension}}:
  pkg.installed:
    - name: {{ php.package_prefix ~ extension }}

  {%- endif %}
{%- endfor %}