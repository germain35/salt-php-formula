{%- from "php/map.jinja" import php with context %}

include:
  - php.common
  - php.cli.config

php_cli_package:
  pkg.installed:
    - name: {{ php.package_prefix ~ php.cli_package_suffix }}
    - require:
      - pkg: php_common_packages