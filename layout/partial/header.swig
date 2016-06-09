<app-header main effects="waterfall resize-title blend-background parallax-background" condenses reveals>
	<app-toolbar class="tall site-header">
		<paper-icon-button icon="menu" paper-drawer-toggle></paper-icon-button>
		<a href="{{ url_for(' ') }}" id="logo" class="title">{{ config.title }}</a>
		{{ header_menu({show_count: false, show_current: true}) }}
		<div class="flex"></div>
		{% if config.multilingual %}{{ list_alternates({
			prepend: '<paper-tabs class="alternate-list" selected="%currentIndex">',
			element: '<paper-tab link class="alternate-list-item"><a class="alternate-list-link" href="%url" hreflang="%lang" title="%title">%lang</a></paper-tab>',
			append: '</paper-tabs>'
		}) }}{% endif %}
	</app-toolbar>
</app-header>
