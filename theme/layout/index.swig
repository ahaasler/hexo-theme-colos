{% for post in page.posts %}
	{{ partial('partial/post', {post: post}) }}
{% endfor %}
