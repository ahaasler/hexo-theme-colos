layout: false
---
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/">
<channel>
		{% set url = config.url + config.root %}
		<title>{{ config.title | escape('xml') }}</title>
		<link>{{ encodeURI(url + page.lang) }}/</link>
		<atom:link href="{{ encodeURI(url + page.path) }}" rel="self" type="application/rss+xml"/>
		<description>{{ config.description | escape('xml') }}</description>
		<language>{{ page.lang }}</language>
		<pubDate>{{ page.posts.first().date.toDate().toUTCString() }}</pubDate>
		<lastBuildDate>{{ page.posts.first().updated.toDate().toUTCString() }}</lastBuildDate>
		<generator>Hexo v{{ env.version }}</generator>
		{% for post in page.posts %}
		<item>
			<title>{{ post.title | escape('xml') }}</title>
			<link>{{ encodeURI(url + post.path) }}</link>
			<guid>{{ encodeURI(url + post.path) }}</guid>
			<pubDate>{{ post.date.toDate().toUTCString() }}</pubDate>
			<description>
			{% if post.description %}
				{{ post.description | escape('xml') }}
			{% elseif post.excerpt %}
				{{ post.excerpt | escape('xml') }}
			{% else %}
				{{ post.content.substring(0, 140) | escape('xml') }}
			{% endif %}
			</description>
			<content:encoded>{{ post.content | escape('xml') }}</content:encoded>
			{% if post.comments %}<comments>{{ encodeURI(url + post.path) }}#disqus_comments</comments>{% endif %}
		</item>
		{% endfor %}
	</channel>
</rss>
