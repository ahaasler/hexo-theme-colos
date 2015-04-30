<header class="site-header">
	<div class="wrapper">
		<h1>
			<a href="{{ url_for('') }}" id="logo">{{ config.title }}</a>
		</h1>
		{{ list_categories({ show_count: false }) }}
	</div>
</header>
