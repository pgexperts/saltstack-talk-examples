packages:
  {% if grains['id'] == 'minion2.example.com' %}
  postgresql_version: '9.3'
  {% else %}
  postgresql_version: '9.2'
  {% endif %}
