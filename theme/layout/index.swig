<colos-grid class="three-cols three-exp narrow-element extra">
	{% for post in page.posts %}
		<div class="item">{{ partial('partial/post', {post: post}) }}</div>
	{% endfor %}
</colos-grid>
