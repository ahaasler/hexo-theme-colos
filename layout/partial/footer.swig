<footer class="site-footer">
	<div class="wrapper">
		<div id="footer-copyright">
			&copy; {{ moment(Date.now()).year() }} {{ mail_to(config.email, config.author) }}
		</div>
		<div id="footer-description">
			<p>{{ config.description }}</p>
		</div>
	</div>
</footer>
