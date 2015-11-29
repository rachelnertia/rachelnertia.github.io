---
layout: page
title: Categories
---

{% for category in site.categories %}
  <h3 id="{{ category[0] }}">{{ category[0] }}</h3>
  <ul>
  {% for post in site.posts %}
  	{% if post.categories contains category[0] %}
      <li><a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endif %}
  {% endfor %}
  </ul>
{% endfor %}