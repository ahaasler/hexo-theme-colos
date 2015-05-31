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
						alternates: getAlternateLangs(category, lang)
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
				post.alternates = getAlternatePosts(posts, post.label, post.lang)
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
	var config = this.config;
	_.forEach(config.language, function(lang, n) {
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
					perPage: config.per_page,
					layout: ['index'],
					format: '/%d/',
					data: {
						lang: lang,
						title: config.title,
						alternates: getAlternateIndices(config, lang)
					}
				})
			);
		}
	});
	return result;
});

function getCategoryByName(categories, name) {
	return categories.toArray().filter(function(category) {
		return category.name == name;
	})[0];
}

function getAlternateLangs(category, currentLang) {
	var result = [];
	_.each(category, function(data, lang) {
		if (currentLang != lang) {
			result.push({
				title: data.name,
				lang: lang,
				path: lang + '/' + data.slug
			});
		}
	});
	return result;
}

function getAlternatePosts(posts, label, currentLang) {
	var alternates = posts.filter(function(post) {
		return post.label == label && post.lang != currentLang;
	});
	var result = [];
	_.each(alternates, function(post) {
		if (currentLang != post.lang) {
			result.push({
				title: post.title,
				lang: post.lang,
				path: post.path
			});
		}
	});
	return result;
}

function getAlternateIndices(config, currentLang) {
	var result = [];
	_.each(config.language, function(lang) {
		if (currentLang != lang && lang != 'default') {
			result.push({
				title: config.title,
				lang: lang,
				path: lang
			});
		}
	});
	return result;
}
