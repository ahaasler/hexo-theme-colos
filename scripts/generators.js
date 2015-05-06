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
      result = result.concat(
        pagination(lang + '/' + data.slug, getCategoryByName(locals.categories, data.category).posts, {
          perPage: perPage,
          layout: ['category', 'archive', 'index'],
          format: paginationDir + '/%d/',
          data: {
            lang: lang,
            title: data.name
          }
        })
      );
    });
  });

  return result;
});

function getCategoryByName(categories, name) {
  return categories.toArray().filter(function(category){
    return category.name == name;
  })[0];
}
