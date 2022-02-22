

https://www.devdungeon.com/content/deploy-angular-apps-nginx

Create a config in /etc/nginx/conf.d/. For example: /etc/nginx/conf.d/mysite.conf. The most important part for Angular in particular is to include the try_files line which will ensure that even if someone visits a URL directly, the server will rewrite it properly so the Angular app behaves properly.

```bash
# /etc/nginx/conf.d/mysife.conf

server {
  listen 0.0.0.0:80;
  root /srv/mysite;
  location / {
    try_files $uri $uri/ /index.html;
  }
}
```