<article class="post">
	{% if is_post() %}
		<header class="post-header">
			<span class="post-category">{{ list_categories(post.categories, {show_count: 0, style: 'none'}) }}</span>
			<span class="post-date">{{ time_tag(post.date, config.post_date_format) }}</span>
		</header>
		<div class="post-content">
			{{ post.content }}
		</div>
	{% else %}
		<paper-card
				{% if post.cover %}image="{{ url_for(post.cover) }}"{% endif %}
				alt="{{ post.title }}">
			<div class="card-content">
				<div class="meta">
					{% if post.categories.size() > 0 %}<span class="post-category">{{ list_categories(post.categories, {show_count: 0, style: 'none'}) }}</span>{% endif %}
					<span class="post-date">{{ time_tag(post.date, config.post_date_format) }}</span>
				</div>
				<h1><a href="{{ url_for(post.path) }}">{{ post.title }}</a></h1>
				{{ post.excerpt || post.content | replace('<figure class="highlight.*?\/figure>', '', "gm") | replace('<h[1-6].*?\/h[1-6]>', '', "gm") | striptags | truncate(140) }}
			</div>
		</paper-card>
	{% endif %}
</article>
