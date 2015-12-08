<header class="site-header">
	<div class="wrapper">
		<h1>
			<a href="{{ url_for(' ') }}" id="logo">{{ config.title }}</a>
		</h1>
		{{ list_categories({show_count: false}) }}
		<nav id="language">
			{% for alternate in _.sortBy(page.alternates, 'lang') %}
				<a href="{{ url_for(alternate.path) }}" hreflang="{{ alternate.lang }}" title="{{ alternate.title }}">
					{{ alternate.lang }}
				</a>
			{% endfor %}
		</nav>
	</div>
</header>
