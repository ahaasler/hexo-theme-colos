var _ = require('lodash');

var regexCache = {
	post: {}
};

hexo.extend.helper.register('get_categories_for_lang', function(lang) {
	var result = [];
	_.each(this.site.data.categories, function(category, title) {
		_.each(category, function(data, categoryLang) {
			if (lang == categoryLang) {
				result = result.concat({
					title: data.name,
					path: lang + '/' + data.slug
				});
			}
		});
	});
	return result;
});
