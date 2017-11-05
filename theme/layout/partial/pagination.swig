<nav class="narrow-element extra pagination">
	{% if is_post() %}
		{% if page.prev %}
			<a href="{{ url_for(page.prev.path) }}" class="previous">{{ __('pagination.page.previous') }}</a>
		{% endif %}
		{% if page.next %}
			<a href="{{ url_for(page.next.path) }}" class="next">{{ __('pagination.page.next') }}</a>
		{% endif %}
	{% else %}
		{% if page.prev %}
			<a href="{{ url_for(page.prev_link) }}" class="previous">{{ __('pagination.page.previous') }}</a>
		{% endif %}
		{% if page.next %}
			<a href="{{ url_for(page.next_link) }}" class="next">{{ __('pagination.page.next') }}</a>
		{% endif %}
	{% endif %}
</nav>
