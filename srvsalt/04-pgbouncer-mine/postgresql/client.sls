{% set pgshortversion = pillar['packages']['postgresql_version'].translate(None, '.') %}
{% set pgversion = pillar['packages']['postgresql_version'] %}

postgresql-client-packages:
  pkg.installed:
    - pkgs:
      - postgresql{{ pgshortversion }}
    - require:
      - pkg: postgresql.org-repo
