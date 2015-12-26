'use strict';

hexo.extend.helper.register('component', function cssHelper() {
  var result = '';
  var path = '';

  for (var i = 0, len = arguments.length; i < len; i++) {
    path = arguments[i];

    if (i) result += '\n';

    if (Array.isArray(path)) {
      result += cssHelper.apply(this, path);
    } else {
      if (path.substring(path.length - 5, path.length) !== '.html') path +=
        '.html';
      result += '<link rel="import" href="' + this.url_for(path) + '">';
    }
  }

  return result;
});
