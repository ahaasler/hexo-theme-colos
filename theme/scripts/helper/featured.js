'use strict';

hexo.extend.helper.register('featured_posts', function featuredPosts() {
  var self = this;
  return this.site.posts.sort('date').filter(function(post) {
    return post.featured === true && (self.config.multilingual === false || self.page.lang === post.lang);
  });
});
