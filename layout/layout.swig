<!DOCTYPE html>
<html lang="{{ page.lang }}">
{{ partial('partial/head') }}
<body class="fullbleed">
	<paper-drawer-panel>
		{{ partial('partial/drawer') }}
		<app-header-layout main mode="waterfall-tall">
			{{ partial('partial/header') }}
			<div class="page-content">
				<div class="wrapper">
					{{ body }}
				</div>
			</div>
			{{ partial('partial/pagination') }}
			{{ partial('partial/footer') }}
		</app-header-layout>
	</paper-drawer-panel>
</body>
</html>
