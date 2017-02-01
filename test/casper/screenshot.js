var viewport = {
	width: 800,
	height: 500
};

casper.test.begin('Take screenshot', 0, function suite(test) {

	casper.start('http://localhost:8000/hexo-theme-colos', function() {
		casper.zoom(0.6);
		casper.viewport(viewport.width, viewport.height);
		casper.wait(2500, function() {
			casper.capture('dist/theme/screenshot.png', {top: 0, left: 0, width: viewport.width, height: viewport.height});
		});
	});

	casper.run(function() {
		test.done();
	});

});
