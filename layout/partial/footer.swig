<footer class="site-footer">
	<div class="wrapper">
		<div id="footer-copyright">
			&copy; {{ moment(Date.now()).year() }} {{ mail_to(config.email, config.author) }}
		</div>
		<div id="footer-description">
			<p>{{ config.description }}</p>
		</div>
		<div id="footer-social">
			<a href="https://twitter.com/{{ theme.social.twitter }}" alt="Twitter"><iron-icon icon="social-iconset:twitter"></iron-icon></a>
			<a href="https://github.com/{{ theme.social.github }}" alt="GitHub"><iron-icon icon="social-iconset:github"></iron-icon></a>
		</div>
	</div>
</footer>
