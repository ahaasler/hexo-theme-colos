'use strict';

hexo.extend.helper.register('header_menu', function headerCategoriesHelper() {
  var categories = getCategories(this, arguments[0]);
  var result = '<style is="custom-style">paper-tab[link] a { @apply(--layout-horizontal); @apply(--layout-center-center); }</style>';
  result += '<paper-tabs class="category-list">';
  for (var i = 0; i < categories.categories.length; i++) {
    result += '<paper-tab link class="category-list-item"><a class="category-list-link" href="' + categories.categories[i].url + '">' + categories.categories[i].name + '</a></paper-tab>';
  }
  result += '</paper-tabs>';
  if (categories.current >= 0) {
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
  var html = self.list_categories(config);
  var result = {
    categories: [],
    current: -1
  };
  var pattern = /<li [^>]*><a [^>]*class="([^"]*)"[^>]*href="([^"]*)"[^>]*>([^a]*)<\/a><\/li>/gi;
  var match;
  var i = 0;
  while (match = pattern.exec(html)) {
    var current = match[1].indexOf('current') >= 0;
    if (current) {
      result.current = i;
    }
    result.categories.push({
      name: match[3],
      url: match[2],
      current: current
    });
    i++;
  }
  return result;
}
