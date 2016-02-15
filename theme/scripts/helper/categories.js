'use strict';

hexo.extend.helper.register('list_categories_header', function headerCategoriesHelper() {
  var result = this.list_categories(arguments[0]);
  result = result.replace(new RegExp("<ul ", 'g'), "<paper-tabs ");
  result = result.replace(new RegExp("</ul>", 'g'), "</paper-tabs>");
  result = result.replace(new RegExp("<li ", 'g'), "<paper-tab ");
  result = result.replace(new RegExp("</li>", 'g'), "</paper-tab>");
  // Get current
  var currentIndex = result.search(/<paper-tab [^>]*><a [^>]*class="[^"]*current[^"]*"[^>]*>/i);
  if (currentIndex > 0) {
    for (var pos = result.search(/<paper-tab /), last = -1, selected = 0; pos !== -1; pos = result.substr(last + 1).search(/<paper-tab /), selected++) {
      last += pos + 1;
      if (last === currentIndex) {
        result = result.replace(new RegExp("<paper-tabs "), '<paper-tabs selected="' + selected + '" ');
        break;
      }
    }
  }
  return result;
});

hexo.extend.helper.register('list_categories_drawer', function drawerCategoriesHelper() {
  var result = this.list_categories(arguments[0]);
  result = result.replace(new RegExp("<ul [^>]+>", 'g'), "");
  result = result.replace(new RegExp("</ul>", 'g'), "");
  result = result.replace(new RegExp("<li ", 'g'), "<paper-drawer-item ");
  result = result.replace(new RegExp("</li>", 'g'), "</paper-drawer-item>");
  return result;
});
