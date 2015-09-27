<nav>
	{% if page.prev %}
		<a href="{{ url_for(page.prev_link) }}">{{ __('pagination.page.previous') }}</a>
	{% endif %}
	{% if page.next %}
		<a href="{{ url_for(page.next_link) }}">{{ __('pagination.page.next') }}</a>
	{% endif %}
</nav>
