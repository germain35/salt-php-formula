{%- from "php/map.jinja" import php with context %}

include:
  - php.fpm

php_fpm_service:
  service.running:
    - name: {{ php.fpm_service }}
    - enable: {{ php.fpm_service_enabled }}
    - reload: {{ php.fpm_service_reload }}
    - require:
        - pkg: php_fpm_package
