{% if pagination == 2 %}
	{% for post in page.posts %}
		{{ partial('partial/post', {post: post}) }}
	{% endfor %}
{% else %}
	{% set last = null %}
	{% for post in page.posts %}
		{% set year = post.date.year() %}
		{% if last != year %}
			{% if last != null %}
				</colos-grid></div></section>
			{% endif %}
			{% set last = year %}
			<section class="archives-wrap">
				<div class="archive-year-wrap">
					<h1>
						<a href="{{ url_for(config.archive_dir + '/' + year) }}" class="archive-year">{{ year }}</a>
					</h1>
				</div>
				<div class="archives">
					<colos-grid class="three-cols three-exp">
		{% endif %}
		<div class="item">{{ partial('partial/post', {post: post}) }}</div>
	{% endfor %}
	{% if (page.posts.length) %}
		</div></section>
	{% endif %}
{% endif %}
{% if page.total > 1 %}
	<nav id="page-nav">
	{% set prev_text = "&laquo; " + __('prev') %}
	{% set next_text = __('next') + " &raquo;" %}
	{{ paginator({
		prev_text: prev_text,
		next_text: next_text
	}) }}
	</nav>
{% endif %}
