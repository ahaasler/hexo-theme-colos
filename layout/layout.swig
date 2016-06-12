<!DOCTYPE html>
<html lang="{{ page.lang }}">
{{ partial('partial/head') }}
<body class="fullbleed">
	<app-drawer-layout>
		{{ partial('partial/drawer') }}
		<app-header-layout mode="waterfall-tall">
			{{ partial('partial/header') }}
			<div class="page-content">
				<div class="wrapper">
					{{ body }}
				</div>
			</div>
			{{ partial('partial/pagination') }}
			{{ partial('partial/footer') }}
		</app-header-layout>
	</app-drawer-layout>
</body>
</html>
