<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width initial-scale=1" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
	<title>{% if page.title %}{{ page.title }} | {% endif %}{{ config.title }}</title>
	<meta name="description" content="{{ config.description }}">
	<meta name="generator" content="Hexo v{{ env.version }}">
	<link rel="canonical" href="{{ url | replace('index.html', '') }}">
	{% if config.multilingual %}{{ list_head_alternates() }}{% endif %}
	<link rel="alternate" type="application/rss+xml" title="{{ __('feed.rss.title') }}" href="{{ encodeURI(config.url + config.root + page.lang + '/feed.xml') }}" />
	{{ css('css/main.css') }}
	{{ js('lib/webcomponentsjs/webcomponents-lite.min.js') }}
	{{ component('lib/elements') }}
	{% if page.cover %}
		<style is="custom-style">
			app-header {
				--app-header-background-front-layer: {
					background-image: url({{ url_for(page.cover) }});
				};
			}
		</style>
	{% endif %}
</head>
