<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width initial-scale=1" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
	<title>{% if page.title %}{{ page.title }} | {% endif %}{{ config.title }}</title>
	<meta name="description" content="{{ config.description }}">
	<meta name="generator" content="Hexo v{{ env.version }}">
	<link rel="canonical" href="{{ url | replace('index.html', '') }}">
	{% for alternate in page.alternates %}
		<link rel="alternate" href="{{ url_for(alternate.path) }}" hreflang="{{ alternate.lang }}" />
	{% endfor %}
</head>
