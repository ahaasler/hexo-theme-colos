<article class="post">
	<header class="post-header">
		{% if not is_post() %}
			<h1>
				<a href="{{ url_for(post.path) }}" class="post-title">{{ post.title }}</a>
			</h1>
		{% endif %}
		<span class="post-date">{{ time_tag(post.date, config.post_date_format) }}</span>
	</header>
	<div class="post-content">
		{% if is_post() %}
			{{ post.content }}
		{% else %}
			{{ post.excerpt || post.content | replace('<figure class="highlight.*?\/figure>', '', "gm") | replace('<h[1-6].*?\/h[1-6]>', '', "gm") | striptags | truncate(140) }}
		{% endif %}
	</div>
</article>
