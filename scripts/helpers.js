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

// This will only be called if hexo multilingual doesn't override it
hexo.extend.helper.register('_c', function(string) {
	return path(this.config, string);
});

/**
 * Retrieve nested item from object/array (http://stackoverflow.com/a/16190716)
 * @param {Object|Array} obj
 * @param {String} path dot separated
 * @param {*} def default value ( if result undefined )
 * @returns {*}
 */
function path(obj, path, def) {
	var i, len;
	for (i = 0, path = path.split('.'), len = path.length; i < len; i++) {
		if (!obj || typeof obj !== 'object') return def;
		obj = obj[path[i]];
	}
	if (obj === undefined) return def;
	return obj;
}
