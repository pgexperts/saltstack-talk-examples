{% set pgshortversion = pillar['packages']['postgresql_version'].translate(None, '.') %}
{% set pgversion = pillar['packages']['postgresql_version'] %}

# Would like to come up with a better way of determining the repo RPM
# but haven't yet
postgresql.org-repo:
  pkg.installed:
    - sources:
      {% if pgshortversion == '92' %}
      - pgdg-centos{{ pgshortversion }}: http://yum.postgresql.org/{{ pgversion }}/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm
      {% elif pgshortversion == '93' %}
      - pgdg-centos{{ pgshortversion }}: http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm
      {% endif %}

