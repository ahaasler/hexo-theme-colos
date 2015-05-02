var pagination = require('hexo-pagination');

hexo.extend.generator.register('category', function(locals){
  var config = this.config;
  if (config.category_generator) {
    var perPage = config.category_generator.per_page;
  } else {
    var perPage = 10;
  }
  var paginationDir = config.pagination_dir || 'page';

  return locals.categories.reduce(function(result, category){
    if (!category.length) return result;

    var posts = category.posts.sort('-date');
    var data = pagination(category.path, posts, {
      perPage: perPage,
      layout: ['category', 'archive', 'index'],
      format: paginationDir + '/%d/',
      data: {
        category: category.name
      }
    });

    return result.concat(data);
  }, []);
});
