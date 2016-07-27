<app-header condenses fixed effects="blend-background parallax-background resize-title waterfall">
	<app-toolbar>
		<paper-icon-button icon="menu" drawer-toggle></paper-icon-button>
		<a href="{{ url_for(' ') }}" id="logo" class="title">{{ config.title }}</a>
		<div condensed-title>{{ page.title }}</div>
		<div class="flex"></div>
		{{ header_menu({show_count: false, show_current: true}) }}
		{% if config.multilingual %}{{ list_alternates({
			prepend: '<paper-dropdown-menu><paper-listbox class="dropdown-content alternate-list" selected="%currentIndex">',
			element: '<paper-item link class="alternate-list-item"><a class="alternate-list-link" href="%url" hreflang="%lang" title="%title">%lang</a></paper-item>',
			append: '</paper-listbox></paper-dropdown-menu>'
		}) }}{% endif %}
	</app-toolbar>
	<app-toolbar class="middle"></app-toolbar>
	<app-toolbar class="bottom">
		<div title>{{ page.title }}</div>
	</app-toolbar>
</app-header>
