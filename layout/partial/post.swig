<article class="post">
	<header class="post-header">
		{% if is_post() %}
			<h1 class="post-title">{{ post.title }}</h1>
		{% else %}
			<h1>
				<a href="{{ url_for(post.path) }}" class="post-title">{{ post.title }}</a>
			</h1>
		{% endif %}
		<span class="post-date">{{ time_tag(post.date, _c('post_date_format')) }}</span>
	</header>
	<div class="post-content">
		{% if is_post() %}
			{{ post.content }}
		{% else %}
			{{ post.excerpt || post.content | replace('<figure class="highlight.*?\/figure>', '', "gm") | striptags | truncate(140) }}
		{% endif %}
	</div>
</article>
