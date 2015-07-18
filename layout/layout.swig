<!DOCTYPE html>
<html lang="{{ page.lang }}">
{{ partial('partial/head') }}
<body>
	{{ partial('partial/header') }}
	<div class="page-content">
		<div class="wrapper">
			{{ body }}
		</div>
	</div>
	{{ partial('partial/pagination') }}
	{{ partial('partial/footer') }}
</body>
</html>
