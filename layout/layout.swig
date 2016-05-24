<!DOCTYPE html>
<html lang="{{ page.lang }}">
{{ partial('partial/head') }}
<body class="fullbleed">
	<paper-drawer-panel>
		{{ partial('partial/drawer') }}
		<paper-header-panel main mode="waterfall-tall">
			{{ partial('partial/header') }}
			<div class="page-content">
				<div class="wrapper">
					{{ body }}
				</div>
			</div>
			{{ partial('partial/pagination') }}
			{{ partial('partial/footer') }}
		</paper-header-panel>
	</paper-drawer-panel>
</body>
</html>
