var CACHE_VERSION = 'v1';
var CACHE_NAME = CACHE_VERSION + ':sw-cache-';

function onSWInstall(event) {
  return event.waitUntil(
    caches.open(CACHE_NAME).then(function prefill(cache) {
      return cache.addAll([]);
    })
  );
}

function onSWActivate(event) {
  return event.waitUntil(
    caches.keys().then(function(cacheNames) {
      return Promise.all(
        cacheNames.filter(function(cacheName) {
          // Return true if you want to remove this cache,
          // but remember that caches are shared across
          // the whole origin
          return cacheName.indexOf(CACHE_VERSION) !== 0;
        }).map(function(cacheName) {
          return caches.delete(cacheName);
        })
      );
    })
  );
}

function onSWPush(event) {
  // event.data are null when Firefox's debugger push
  // event.data are PushMessageData object and cannot exec event.data.json, event.data.text => 'Test push message from DevTools.'
  var json = event.data ? event.data.json() : {"title" : "DEBUG TITLE", "body" : "DEBUG BODY"};
  return event.waitUntil(
    self.registration.showNotification(json.title, {
      body: json.body,
      icon: json.icon,
      data: {
        target_url: json.target_url
      }
    })
  );
}

function onSWNotificationClick(event) {
  event.notification.close();
  return event.waitUntil(
    clients.openWindow(event.notification.data != null ? event.notification.data.target_url : '/')
  );
}

self.addEventListener('install', onSWInstall);
self.addEventListener('activate', onSWActivate);
self.addEventListener("push", onSWPush);
self.addEventListener("notificationclick", onSWNotificationClick);
