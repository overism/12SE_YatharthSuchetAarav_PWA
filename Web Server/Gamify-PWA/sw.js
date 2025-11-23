const CACHE_NAME = `gamify-PWA-v1`;

// Use the install event to pre-cache all initial resources.
self.addEventListener('install', event => {
  event.waitUntil((async () => {
    const cache = await caches.open(CACHE_NAME);
    cache.addAll([
      '/',
      '/gamify.js',
      '/gamify.css'
    ]);
  })());
});

self.addEventListener('fetch', event => {
  event.respondWith((async () => {
    const cache = await caches.open(CACHE_NAME);

    // Get the resource from the cache.
    const cachedResponse = await cache.match(event.request);
    if (cachedResponse) {
      return cachedResponse;
    } else {
        try {
          // If the resource was not in the cache, try the network.
          const fetchResponse = await fetch(event.request);

          // Save the resource in the cache and return it.
          cache.put(event.request, fetchResponse.clone());
          return fetchResponse;
        } catch (e) {
          // The network failed.
        }
    }
  })());
});

// service worker: handle saving/serving user bio in Cache Storage
const USER_CACHE = 'user-data-v1';
self.addEventListener('install', (e) => {
  self.skipWaiting();
});
self.addEventListener('activate', (e) => {
  e.waitUntil((async () => {
    await self.clients.claim();
    // keep only current cache name (optional)
    const keys = await caches.keys();
    await Promise.all(keys.map(k => (k !== USER_CACHE) ? caches.delete(k) : Promise.resolve()));
  })());
});

// Intercept POST /save-bio to store the bio, and GET /user/bio to return stored bio
self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);
  // Only handle same-origin, specific paths
  if (url.origin === self.location.origin && url.pathname === '/save-bio' && event.request.method === 'POST') {
    event.respondWith((async () => {
      try {
        const data = await event.request.json();
        const bio = (data && data.bio) ? data.bio : '';
        const payload = { bio, updated: new Date().toISOString() };
        const cache = await caches.open(USER_CACHE);
        // store payload at request key '/user/bio'
        await cache.put('/user/bio', new Response(JSON.stringify(payload), {
          headers: { 'Content-Type': 'application/json' }
        }));
        return new Response(JSON.stringify({ ok: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
      } catch (err) {
        return new Response(JSON.stringify({ ok: false, error: 'save-failed' }), { status: 500, headers: { 'Content-Type': 'application/json' } });
      }
    })());
    return;
  }

  if (url.origin === self.location.origin && url.pathname === '/user/bio' && event.request.method === 'GET') {
    event.respondWith((async () => {
      const cache = await caches.open(USER_CACHE);
      const match = await cache.match('/user/bio');
      if (match) return match;
      // nothing cached: return 204/no content
      return new Response(JSON.stringify({ bio: '' }), { status: 200, headers: { 'Content-Type': 'application/json' } });
    })());
    return;
  }

  // otherwise default fetch behaviour (let network or other fetch handlers)
});