{%- from "php/map.jinja" import php with context %}

php_dev_package:
  pkg.installed:
    - name: {{ php.package_prefix ~ dev_package_suffix }}
