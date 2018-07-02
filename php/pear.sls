{%- from "php/map.jinja" import php with context %}

include:
  - php.common

{% set pear_package = salt['grains.filter_by']({
    'Debian': 'php-' ~ php.pear_package_suffix,
    'RedHat': php.package_prefix ~ php.pear_package_suffix,
    'FreeBSD': php.pear_package_suffix,
}
, grain="os_family"
, default='Debian') %}

php_pear_package:
  pkg.installed:
    - name: {{ pear_package }}
    - require:
      - pkg: php_common_packages