<nav>
	{% if page.prev %}
		<a href="{{ url_for(page.prev_link) }}">Previous</a>
	{% endif %}
	{% if page.next %}
		<a href="{{ url_for(page.next_link) }}">Next</a>
	{% endif %}
</nav>
