<header class="site-header">
	<paper-toolbar>
		<paper-icon-button icon="menu" paper-drawer-toggle></paper-icon-button>
		<a href="{{ url_for(' ') }}" id="logo" class="title">{{ config.title }}</a>
		{{ header_menu({show_count: false, show_current: true}) }}
	</paper-toolbar>
	<div class="wrapper">
		<nav id="language">
			{% for alternate in _.sortBy(page.alternates, 'lang') %}
				<a href="{{ url_for(alternate.path) }}" hreflang="{{ alternate.lang }}" title="{{ alternate.title }}">
					{{ alternate.lang }}
				</a>
			{% endfor %}
		</nav>
	</div>
</header>
