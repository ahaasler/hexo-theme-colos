<footer class="site-footer">
	<div class="wrapper">
		<div id="footer-copyright">
			&copy; {{ moment(Date.now()).year() }} {{ mail_to(_c('email'), _c('author')) }}
		</div>
		<div id="footer-description">
			<p>{{ _c('description') }}</p>
		</div>
	</div>
</footer>
