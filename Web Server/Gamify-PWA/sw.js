const CACHE_NAME = 'gamify-v1';
const OFFLINE_PAGE = '/offline.html';
const BASE = '/12SE_YatharthSuchetAarav_PWA';

const STATIC_ASSETS = [
  `${BASE}/`,
  `${BASE}/index.html`,
  `${BASE}/login.html`,
  `${BASE}/profile.html`,
  `${BASE}/offline.html`,
  `${BASE}/manifest.json`,
  `${BASE}/sw.js`,
  `${BASE}/static/css/login.css`,
  `${BASE}/static/images/GAMIFY_LOGO.png`
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(STATIC_ASSETS))
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(
        keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))
      )
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', event => {
  if (event.request.mode === 'navigate') {
    event.respondWith(
      fetch(event.request).catch(() => caches.match(OFFLINE_PAGE))
    );
    return;
  }

  event.respondWith(
    caches.match(event.request).then(cached =>
      cached ||
      fetch(event.request).then(response => {
        return caches.open(CACHE_NAME).then(cache => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    )
  );
});
