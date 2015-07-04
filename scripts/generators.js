var pagination = require('hexo-pagination');
var _ = require('lodash');

hexo.extend.generator.register('category', function(locals) {
	var config = this.config;
	var categories = locals.data.categories;
	if (config.category_generator) {
		var perPage = config.category_generator.per_page;
	} else {
		var perPage = 10;
	}
	var paginationDir = config.pagination_dir || 'page';
	var result = [];

	_.each(categories, function(category, title) {
		_.each(category, function(data, lang) {
			result = result.concat(
				pagination(lang + '/' + data.slug, getCategoryByName(
					locals.categories,
					data.category).posts, {
					perPage: perPage,
					layout: ['category', 'archive', 'index'],
					format: paginationDir + '/%d/',
					data: {
						lang: lang,
						title: data.name,
						category: data.category,
						alternates: getAlternateCategories(category)
					}
				})
			);
		});
	});

	return result;
});

hexo.extend.generator.register('posts', function(locals) {
	var posts = locals.posts.sort('-date').toArray();
	var length = posts.length;

	return posts.map(function(post, i) {
		var layout = post.layout;
		var path = post.path;

		if (!layout || layout === 'false') {
			return {
				path: path,
				data: post.content
			};
		} else {
			if (i) post.prev = posts[i - 1];
			if (i < length - 1) post.next = posts[i + 1];

			var layouts = ['post', 'page', 'index'];
			if (layout !== 'post') layouts.unshift(layout);

			if (post.label && post.lang) {
				post.alternates = getAlternatePosts(posts, post.label)
			}

			return {
				path: path,
				layout: layouts,
				data: post
			};
		}
	});
});

hexo.extend.generator.register('index', function(locals) {
	var result = [];
	var context = this;
	context.locals = locals;
	_.forEach(context.config.language, function(lang, n) {
		if (n == 0) {
			result = result.concat(
				{
					path: '',
					data: {
						redirect: lang
					},
					layout: ['redirect']
				}
			);
		}
		if (lang != 'default') {
			result = result.concat(
				pagination(lang, locals.posts.sort('-date').toArray().filter(
					function(post) {
						return post.lang == lang;
					}), {
					perPage: context.config.per_page,
					layout: ['index'],
					format: '/%d/',
					data: {
						lang: lang,
						title: _c('title', lang, context),
						alternates: getAlternateIndices(context)
					}
				})
			);
		}
	});
	return result;
});

hexo.extend.generator.register('feed', function(locals) {
	var result = [];
	var context = this;
	context.locals = locals;
	_.forEach(context.config.language, function(lang) {
		if (lang != 'default') {
			result.push(
				{
					path: lang + '/feed.xml',
					data: {
						title: _c('title', lang, context),
						lang: lang,
						posts: locals.posts.sort('-updated').filter(function(post) {
							return post.lang == lang;
						})
					},
					layout: ['rss2']
				}
			)
		}
	});
	return result;
});

function getCategoryByName(categories, name) {
	return categories.toArray().filter(function(category) {
		return category.name == name;
	})[0];
}

function getAlternateCategories(category) {
	var result = [];
	_.each(category, function(data, lang) {
		result.push({
			title: data.name,
			lang: lang,
			path: lang + '/' + data.slug
		});
	});
	return result;
}

function getAlternatePosts(posts, label) {
	var alternates = posts.filter(function(post) {
		return post.label == label;
	});
	var result = [];
	_.each(alternates, function(post) {
		result.push({
			title: post.title,
			lang: post.lang,
			path: post.path
		});
	});
	return result;
}

function getAlternateIndices(context) {
	var result = [];
	_.each(context.config.language, function(lang) {
		if (lang != 'default') {
			result.push({
				title: _c('title', lang, context),
				lang: lang,
				path: lang
			});
		}
	});
	return result;
}

function _c(string, lang, context) {
	if (context.locals.data['config_' + lang] != null) {
		return path(context.locals.data['config_' + lang], string) || path(context.config, string);
	}
	return path(context.config, string);
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
