{% if page.title %}
	<h1>{{ page.title }}</h1>
{% endif %}
{% for post in page.posts %}
	{{ partial('partial/post', {post: post}) }}
{% endfor %}
