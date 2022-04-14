---
layout: default
title: Blog
---

<div class="row row-cols-1">
{% for post in site.posts %}
 <div class="col border-bottom my-3 pb-3">
   <h2>{{ post.title }}</h2>
   {% if post.author %}
   <h6 class="text-muted">{{ post.date | date: '%B %d, %Y' }} by {{ post.author }}</h6>
   {% else %}
   <h6 class="text-muted">{{ post.date | date: '%B %d, %Y' }}</h6>
   {% endif %}
   <p>{{ post.excerpt }}</p>
   <a class="text-muted" href="{{ post.url }}"><small>Read more...</small></a>
 </div>
{% endfor %}
</div>
