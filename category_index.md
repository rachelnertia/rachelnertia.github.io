---
layout: page
title: Categories
---

{% assign cats = (site.categories | sort:0) %}
{% for category in cats %}
  <h3 id="{{ category[0] }}">{{ category[0] }}</h3>
  <ul>
  {% for post in site.posts %}
  	{% if post.categories contains category[0] %}
      <li><a href="{{ post.url }}">{{ post.title }}</a> {{ post.date | date_to_string }} </li>
    {% endif %}
  {% endfor %}
  </ul>
{% endfor %}
<h3 id="uncategorised">Uncategorised</h3>
<ul>
  {% for post in site.posts %}
  	{% if post.categories.size == 0 %}
      <li><a href="{{ post.url }}">{{ post.title }}</a> {{ post.date | date_to_string }} </li>
    {% endif %}
  {% endfor %}
</ul>