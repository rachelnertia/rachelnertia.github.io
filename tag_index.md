---
layout: page
title: Tag Index
---

{% for tag in site.tags %}
  <h3 id="{{ tag[0] }}">{{ tag[0] }}</h3>
  <ul>
  {% for post in site.posts %}
  	{% if post.tags contains tag[0] %}
      <li><a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endif %}
  {% endfor %}
  </ul>
{% endfor %}