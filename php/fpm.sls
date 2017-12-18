{%- from "php/map.jinja" import php with context %}

include:
  - php.common
  - php.fpm.config
  - php.fpm.pool
  - php.fpm.service

php_fpm_package:
  pkg.installed:
    - name: {{ php.package_prefix ~ php.fpm_package_suffix }}
    - require:
      - pkg: php_common_packages