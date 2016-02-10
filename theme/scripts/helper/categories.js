'use strict';

hexo.extend.helper.register('list_categories_header', function headerCategoriesHelper() {
  var result = this.list_categories(arguments[0]);
  result = result.replace(new RegExp("<ul ", 'g'), "<paper-tabs ");
  result = result.replace(new RegExp("</ul>", 'g'), "</paper-tabs>");
  result = result.replace(new RegExp("<li ", 'g'), "<paper-tab ");
  result = result.replace(new RegExp("</li>", 'g'), "</paper-tab>");
  return result;
});
