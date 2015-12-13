casper.options.viewportSize = {
	width: 940,
	height: 580
};

casper.test.begin('Take screenshot', 0, function suite(test) {

	casper.start('http://localhost:8080/hexo-theme-colos', function() {
		casper.capture('dist/theme/screenshot.png');
	});

	casper.run(function() {
		test.done();
	});

});
