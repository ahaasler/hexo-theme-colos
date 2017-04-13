'use strict';

hexo.extend.helper.register('sticky_posts', function stickyPosts() {
  return this.site.posts.sort('date').filter(function(post) {
    return post.sticky === true;
  });
});
