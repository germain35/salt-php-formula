{%- from "php/map.jinja" import php with context %}

include:
  - php.common
  
php_packages:
  pkg.installed:
    - pkgs:
      {%- for package_suffix in php.packages %}
        {%- if package_suffix in ['pear', 'apcu-bc'] %}
      - {{ 'php-' ~ package_suffix }}
        {%- else %}
      - {{ php.package_prefix ~ package_suffix }}
        {%- endif %}
      {%- endfor %}
