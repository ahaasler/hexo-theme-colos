<article class="post">
	{% if is_post() %}
		<header class="post-header">
			<span class="post-date">{{ time_tag(post.date, config.post_date_format) }}</span>
		</header>
		<div class="post-content">
			{{ post.content }}
		</div>
	{% else %}
		<paper-card
				heading="{{ post.title }}"
				{% if post.cover %}image="{{ url_for(post.cover) }}"{% endif %}
				alt="{{ post.title }}">
			<div class="card-content">
				{{ post.excerpt || post.content | replace('<figure class="highlight.*?\/figure>', '', "gm") | replace('<h[1-6].*?\/h[1-6]>', '', "gm") | striptags | truncate(140) }}
			</div>
		</paper-card>
	{% endif %}
</article>
