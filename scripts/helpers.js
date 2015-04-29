var regexCache = {
	post: {}
};

hexo.extend.helper.register('is_post', function() {
	var permalink = this.config.permalink;
	var r = regexCache.post[permalink];
	if (!r){
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
