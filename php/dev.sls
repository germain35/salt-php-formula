{%- from "php/map.jinja" import php with context %}

php_compiler_packages:
  pkg.installed:
    pkgs: {{ php.compiler_packages }}

php_dev_package:
  pkg.installed:
    - name: {{ php.package_prefix ~ php.dev_package_suffix }}
    - require:
      - pkg: php_compiler_packages
