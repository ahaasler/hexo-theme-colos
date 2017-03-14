<nav class="narrow-element extra">
	{% if is_post() %}
		{% if page.prev %}
			<a href="{{ url_for(page.prev.path) }}">{{ __('pagination.page.previous') }}</a>
		{% endif %}
		{% if page.next %}
			<a href="{{ url_for(page.next.path) }}">{{ __('pagination.page.next') }}</a>
		{% endif %}
	{% else %}
		{% if page.prev %}
			<a href="{{ url_for(page.prev_link) }}">{{ __('pagination.page.previous') }}</a>
		{% endif %}
		{% if page.next %}
			<a href="{{ url_for(page.next_link) }}">{{ __('pagination.page.next') }}</a>
		{% endif %}
	{% endif %}
</nav>
