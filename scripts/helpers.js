var _ = require('lodash');

var regexCache = {
	post: {}
};

hexo.extend.helper.register('is_post', function() {
	var permalink = this.config.permalink;
	var r = regexCache.post[permalink];
	if (!r) {
		var rUrl = permalink
			.replace(':lang', '[a-zA-Z]{1,8}(-[a-zA-Z0-9]{1,8})*')
			.replace(':id', '\\d+')
			.replace(':category', '(\\w+\\/?)+')
			.replace(':year', '\\d{4}')
			.replace(/:(month|day)/g, '\\d{2}')
			.replace(/:i_(month|day)/g, '\\d{1,2}')
			.replace(/:title/, '[^\\/]+');
		r = regexCache.post[permalink] = new RegExp(rUrl);
	}
	return r.test(this.path);
});

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

hexo.extend.helper.register('_c', function(string) {
	if (this.site.data['config_' + this.page.lang]) {
		return this.site.data['config_' + this.page.lang][string] || this.config[string];
	}
	return this.config[string];
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
