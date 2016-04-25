'use strict';

hexo.extend.helper.register('header_menu', function headerCategoriesHelper() {
  var categories = getCategories(this, arguments[0]);
  console.log(categories);
  var result = categories.html;
  result = '<style is="custom-style">paper-tab[link] a { @apply(--layout-horizontal); @apply(--layout-center-center); }</style>' + result;
  result = result.replace(new RegExp("<ul ", 'g'), "<paper-tabs ");
  result = result.replace(new RegExp("</ul>", 'g'), "</paper-tabs>");
  result = result.replace(new RegExp("<li ", 'g'), "<paper-tab link ");
  result = result.replace(new RegExp("</li>", 'g'), "</paper-tab>");
  if (categories.current > 0) {
    result = result.replace(new RegExp("<paper-tabs "), '<paper-tabs selected="' + categories.current + '" ');
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

function getCategories(self, config) {
  var categories = {
    html: self.list_categories(config),
    current: -1
  };
  // Get current
  var currentIndex = categories.html.search(/<li [^>]*><a [^>]*class="[^"]*current[^"]*"[^>]*>/i);
  if (currentIndex > 0) {
    for (var pos = categories.html.search(/<li /), last = -1, selected = 0; pos !== -1; pos = categories.html.substr(last + 1).search(/<li /), selected++) {
      last += pos + 1;
      if (last === currentIndex) {
        categories.current = selected;
        break;
      }
    }
  }
  return categories;
}
