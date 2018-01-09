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
    - require:
      - pkg: php_pear_package

php_extension_{{extension.name}}_ini_file:
  file.prepend:
    - name: {{ php.conf_root_ini | path_join(extension.name ~ '.ini') }}
    - text:
      - extension={{extension.name}}.so
    - require:
      - pecl: php_extension_{{extension.name}}

    {%- if php.fpm_enabled %}

php_extension_{{extension.name}}_cgi_symlink:
  file.symlink:
    - name: {{ php.cgi_conf_dir | path_join('20-' ~ extension.name ~ '.ini') }}
    - target: {{ php.conf_root_ini | path_join(extension.name ~ '.ini') }}
    - force: True
    - makedirs: True

php_extension_{{extension.name}}_fpm_symlink:
  file.symlink:
    - name: {{ php.fpm_conf_dir | path_join('20-' ~ extension.name ~ '.ini') }}
    - target: {{ php.conf_root_ini | path_join(extension.name ~ '.ini') }}
    - force: True
    - makedirs: True
    - watch_in:
      - service: php_fpm_service

    {%- endif %}

    {%- if php.cli_enabled %}

php_extension_{{extension.name}}_cli_symlink:
  file.symlink:
    - name: {{ php.cli_conf_dir | path_join('20-' ~ extension.name ~ '.ini') }}
    - target: {{ php.conf_root_ini | path_join(extension.name ~ '.ini') }}
    - force: True
    - makedirs: True

    {%- endif %}
  {%- else %}

php_extension_{{extension.name}}:
  pkg.installed:
    - name: {{ php.package_prefix ~ extension.name }}

  {%- endif %}
{%- endfor %}