{%- from "php/map.jinja" import php with context %}

include:
  - php.common
  
php_packages:
  pkg.installed:
    - pkgs:
      {%- for package_suffix in php.packages %}
      - {{ php.package_prefix ~ package_suffix }}
      {%- endfor %}
