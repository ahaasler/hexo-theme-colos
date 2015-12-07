casper.test.begin('Index has title', 1, function suite(test) {

  casper.start('http://localhost:8000/', function() {
    test.assertTitle('Colos', 'title is the one expected');
  });

  casper.run(function() {
    test.done();
  });

});
