<header class="site-header">
	<div class="wrapper">
		<h1>
			<a href="{{ url_for('') }}" id="logo">{{ config.title }}</a>
		</h1>
		<ul class="category-list">
			{% for category in get_categories_for_lang(page.lang) %}
				<li class="category-list-item"><a class="category-list-link" href="{{ url_for(category.path) }}">{{ category.title }}</a></li>
			{% endfor %}
		</ul>
	</div>
</header>
