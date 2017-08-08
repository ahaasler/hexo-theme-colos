'use strict';

hexo.extend.helper.register('list_social', function listSocial() {
  var result = '';
  var social = this.theme.social || {};
  for (var type in social) {
    if (social.hasOwnProperty(type)) {
      result += '<a href="' + this.url_for_social(type) + '" alt="' + type + '"><iron-icon icon="social-iconset:' + type + '"></iron-icon></a>'
    }
  }
  return result;
});

hexo.extend.helper.register('url_for_social', function urlForSocial(type, value) {
  value = value || this.theme.social[type];
  // Regex by Daveo on https://stackoverflow.com/a/3809435
  var urlRegExp = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi;
  if (new RegExp(urlRegExp).test(value)) {
    return value;
  }
  switch (type) {
    case 'github':
      return 'https://github.com/' + value;
    case 'googleplus':
      return 'https://plus.google.com/' + value;
    case 'instagram':
      return 'https://www.instagram.com/' + value;
    case 'twitter':
      return 'https://twitter.com/' + value;
    default:
      return '#';
  }
});
