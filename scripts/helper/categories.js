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

function getMenu(self) {
  var menu = self.theme.menu || [
    {
      "type": "link",
      "title": "home",
      "path": "/"
    },
    {
      "type": "categories"
    }
  ];
  var result = {
    elements: [],
    current: -1
  };
  var currentPath = self.path.replace(/^\//g, '').replace(/index\.html$/g, '');
  menu.forEach(function (element, index) {
    switch (element.type) {
      case 'link':
        var elementPath = element.path.replace(/^\//g, '').replace(/index\.html$/g, '');
        var isCurrent = elementPath.length > 3 ? currentPath.indexOf(elementPath) > -1 : currentPath === elementPath;
        if (isCurrent) {
          result.current = index;
        }
        result.elements.push({
          name: element.title,
          url: self.url_for(element.path),
          current: isCurrent
        });
        break;
      case 'categories':
        var categories = getCategories(self, {show_count: false, show_current: true});
        if (categories.current > -1) {
          result.current = categories.current + index;
        }
        categories.categories.forEach(function(category) {
          result.elements.push(category);
        });
        break;
    }
  });
  return result;
}

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
