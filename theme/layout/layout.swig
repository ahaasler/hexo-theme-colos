<!DOCTYPE html>
<html lang="{{ page.lang }}">
{{ partial('partial/head') }}
<body>
	<paper-drawer-panel>
		<div drawer>Drawer</div>
		<div main>
			{{ partial('partial/header') }}
			<div class="page-content">
				<div class="wrapper">
					{{ body }}
				</div>
			</div>
			{{ partial('partial/pagination') }}
			{{ partial('partial/footer') }}
		</div>
	</paper-drawer-panel>
</body>
</html>
