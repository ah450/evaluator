jprApp.filter('encodeuri', function() {
  // use native escape
  return window.encodeURIComponent;
});

jprApp.filter('unencodeuri', function() {
  return window.decodeURIComponent;
});