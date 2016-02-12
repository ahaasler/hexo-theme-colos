casper.options.viewportSize = {
	width: 800,
	height: 500
};

casper.test.begin('Take screenshot', 0, function suite(test) {

	casper.start('http://localhost:8000/hexo-theme-colos', function() {
		casper.wait(1500, function() {
			casper.capture('dist/theme/screenshot.png');
		});
	});

	casper.run(function() {
		test.done();
	});

});
