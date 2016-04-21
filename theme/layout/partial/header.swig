<header class="site-header">
	<paper-toolbar>
		<paper-icon-button icon="menu" paper-drawer-toggle></paper-icon-button>
		<a href="{{ url_for(' ') }}" id="logo" class="title">{{ config.title }}</a>
		{{ header_menu({show_count: false, show_current: true}) }}
		{% if config.multilingual %}{{ list_alternates({
			prepend: '<paper-tabs class="alternate-list" selected="%currentIndex">',
			element: '<paper-tab link class="alternate-list-item"><a class="alternate-list-link" href="%url" hreflang="%lang" title="%title">%lang</a></paper-tab>',
			append: '</paper-tabs>'
		}) }}{% endif %}
	</paper-toolbar>
</header>
