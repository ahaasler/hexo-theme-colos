var pagination = require('hexo-pagination');
var _ = require('lodash');

hexo.extend.generator.register('category', function(locals) {
	var config = this.config;
	var categories = locals.data.categories;
	var result = [];

	_.each(categories, function(category, title) {
		_.each(category, function(data, lang) {
			var catData = getCategoryByName(locals.categories, data.category);
			result = result.concat(pagination(
				lang + '/' + data.slug,
				catData != null ? catData.posts : [], {
					perPage: _c('category_generator.per_page', lang, config, locals) || _c('per_page', lang, config, locals),
					layout: ['category', 'archive', 'index'],
					format: _c('pagination_dir', lang, config, locals) + '/%d/',
					data: {
						lang: lang,
						title: data.name,
						category: data.category,
						alternates: getAlternateCategories(category),
						is_category: true
					}
				}
			));
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

			post.is_post = true;

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

hexo.extend.generator.register('feed', function(locals) {
	var result = [];
	var config = this.config;
	_.forEach(config.language, function(lang) {
		if (lang != 'default') {
			result.push({
				path: lang + '/feed.xml',
				data: {
					title: _c('title', lang, config, locals),
					lang: lang,
					posts: locals.posts.sort('-updated').filter(function(post) {
						return post.lang == lang;
					}),
					is_feed: true
				},
				layout: ['rss2']
			})
		}
	});
	return result;
});

hexo.extend.generator.register('archive', function(locals) {
	var config = this.config;
	var archiveDir = config.archive_dir;
	var paginationDir = config.pagination_dir || 'page';
	var allPosts = locals.posts.sort('-date');
	var perPage = config.archive_generator.per_page;
	var result = [];

	if (!allPosts.length) return;

	if (archiveDir[archiveDir.length - 1] !== '/') archiveDir += '/';

	function generate(path, posts, options){
		options = options || {};
		options.archive = true;

		result = result.concat(pagination(path, posts, {
			perPage: perPage,
			layout: ['archive', 'index'],
			format: paginationDir + '/%d/',
			data: options
		}));
	}

	generate(archiveDir, allPosts);

	if (!config.archive_generator.yearly) return result;

	var posts = {};

	// Organize posts by date
	allPosts.forEach(function(post){
		var date = post.date;
		var year = date.year();
		var month = date.month() + 1; // month is started from 0

		if (!posts.hasOwnProperty(year)){
			// 13 arrays. The first array is for posts in this year
			// and the other arrays is for posts in this month
			posts[year] = [
				[], [], [], [], [], [], [], [], [], [], [], [], []
			];
		}

		posts[year][0].push(post);
		posts[year][month].push(post);
	});

	var Query = this.model('Post').Query;
	var years = Object.keys(posts);
	var year, data, month, monthData, url;

	// Yearly
	for (var i = 0, len = years.length; i < len; i++){
		year = +years[i];
		data = posts[year];
		url = archiveDir + year + '/';
		if (!data[0].length) continue;

		generate(url, new Query(data[0]), {year: year});

		if (!config.archive_generator.monthly) continue;

		// Monthly
		for (month = 1; month <= 12; month++){
			monthData = data[month];
			if (!monthData.length) continue;

			generate(url + (month < 10 ? '0' + month : month) + '/', new Query(monthData), {
				year: year,
				month: month
			});
		}
	}

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
