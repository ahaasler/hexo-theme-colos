<app-header condenses fixed
		effects="blend-background parallax-background resize-snapped-title waterfall"
		effects-config='{"resize-snapped-title": {"startsAt": 0.6}}'>
	<app-toolbar>
		<paper-icon-button icon="menu" drawer-toggle></paper-icon-button>
		<a href="{{ url_for(' ') }}" id="logo" class="title">{{ config.title }}</a>
		<div condensed-title></div>
		<div class="flex"></div>
		{{ header_menu({show_count: false, show_current: true}) }}
		<div class="flex"></div>
		{% if config.multilingual %}{{ list_alternates({
			prepend: '<paper-tabs class="alternate-list" selected="%currentIndex">',
			element: '<paper-tab link class="alternate-list-item"><a class="alternate-list-link" href="%url" hreflang="%lang">%lang</a></paper-tab>',
			append: '</paper-tabs>'
		}) }}{% endif %}
	</app-toolbar>
	<app-toolbar class="middle"></app-toolbar>
	{% if is_home() %}
		<app-toolbar class="bottom">
			<div main-title>
				{% for post in page.posts %}
					<span slide{% if post.cover %} bg="{{ post.cover }}"{% endif %}>{{ post.title }}</span>
				{% endfor %}
			</div>
		</app-toolbar>
	{% else %}
		<app-toolbar class="bottom">
			<div main-title>{{ page.title }}</div>
		</app-toolbar>
	{% endif %}
</app-header>
