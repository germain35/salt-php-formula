{%- from "php/map.jinja" import php with context %}

php_common_packages:
  pkg.installed:
    - pkg:
      {%- for common_suffix in php.common_package_suffixes %}
      - {{ php.package_prefix ~ common_suffix }}
      {%- endfor %}
