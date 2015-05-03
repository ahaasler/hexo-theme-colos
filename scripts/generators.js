var pagination = require('hexo-pagination');
var _ = require('lodash');

hexo.extend.generator.register('category', function(locals){
  var config = this.config;
  var categories = locals.data.categories;
  if (config.category_generator) {
    var perPage = config.category_generator.per_page;
  } else {
    var perPage = 10;
  }
  var paginationDir = config.pagination_dir || 'page';
  var result = [];

  _.each(categories, function(data, title) {
    _.each(data, function(data, lang) {
      result = result.concat({
        path: lang + '/' + data.slug + '/index.html',
        data: {
          posts: getCategoryByName(locals.categories, data.category).posts
        },
        layout: ['archive', 'index']
      });
    });
  });

  return result;
});

function getCategoryByName(categories, name) {
  return categories.toArray().filter(function(category){
    return category.name == name;
  })[0];
}
