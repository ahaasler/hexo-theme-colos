var pagination = require('hexo-pagination');
var _ = require('lodash');

hexo.extend.generator.register('index', function(locals) {
	var result = [];
	var config = this.config;
	_.forEach(config.language, function(lang, n) {
		if (n == 0) {
			result = result.concat({
				path: '',
				data: {
					redirect: lang
				},
				layout: ['redirect']
			});
		}
		if (lang != 'default') {
			result = result.concat(
				pagination(lang, locals.posts.sort('-date').toArray().filter(
					function(post) {
						return post.lang == lang;
					}), {
					perPage: _c('per_page', lang, config, locals),
					layout: ['index'],
					format: _c('pagination_dir', lang, config, locals) + '/%d/',
					data: {
						lang: lang,
						title: _c('title', lang, config, locals),
						alternates: getAlternateIndices(config, locals),
						is_index: true
					}
				})
			);
		}
	});
	return result;
});

function getAlternateIndices(config, locals) {
	var result = [];
	_.each(config.language, function(lang) {
		if (lang != 'default') {
			result.push({
				title: _c('title', lang, config, locals),
				lang: lang,
				path: lang
			});
		}
	});
	return result;
}

function _c(string, lang, config, locals) {
	if (locals.data['config_' + lang] != null) {
		return path(locals.data['config_' + lang], string) || path(config, string);
	}
	return path(config, string);
}

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
