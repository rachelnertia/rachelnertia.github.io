---
layout: page
title: Tag Index
---

{% assign sorted_tags = site.tags | sort %}
{% for tag in sorted_tags %}
  <h3 id="{{ tag[0] }}">{{ tag[0] }}</h3>
  <ul>
  {% for post in site.posts %}
  	{% if post.tags contains tag[0] %}
      <li><a href="{{ post.url }}">{{ post.title }}</a> {{ post.date | date_to_string }} </li>
    {% endif %}
  {% endfor %}
  </ul>
{% endfor %}