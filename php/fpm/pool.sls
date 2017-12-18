{%- from "php/map.jinja" import php with context %}

include:
  - php.fpm
  - php.fpm.config
  - php.fpm.service

{%- if php.fpm is defined and php.fpm.pools is defined %}
  {%- for pool, params in php.fpm.pools.iteritems() %}
php_fpm_pool_{{pool}}:
  file.managed:
    - name: {{ php.fpm_pool_dir ~ '/' ~ pool ~ '.conf' }}
    - source: salt://php/templates/fpm/pool.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - defaults:
      pool: {{ pool }}
    - require:
      - pkg: php_fpm_package
    - watch_in:
      - service: php_fpm_service
  {%- endfor %}
{%- endif %}