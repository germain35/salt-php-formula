{%- from "php/map.jinja" import php with context %}

include:
  - php.common
  
php_packages:
  pkg.installed:
    - pkgs:
      {%- for package_suffix in php.packages %}
        {%- if php.major_version == '7' %}
      - {{ 'php-' ~ package_suffix }}
        {%- else %}
      - {{ php.package_prefix ~ package_suffix }}
        {%- endif %}
      {%- endfor %}
