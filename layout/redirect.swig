layout: false
---
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8" />
		<meta http-equiv="refresh" content="1;url={{ url_for(page.redirect) }}" />
		<link rel="canonical" href="{{ url_for(page.redirect) }}" />
		<script type="text/javascript">
			window.location.href = "{{ url_for(page.redirect) }}"
		</script>
		<title>Page Redirection</title>
	</head>
	<body>
		If you are not redirected automatically, follow <a href='{{ url_for(page.redirect) }}'>this link</a>.
	</body>
</html>
