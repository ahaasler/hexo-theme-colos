'use strict';

hexo.extend.helper.register('featured_posts', function featuredPosts() {
  return this.site.posts.sort('date').filter(function(post) {
    return post.featured === true;
  });
});
