
server {
    listen 443 default_server ssl http2;
    listen [::]:443 ssl http2;

    server_name host.example.com;

    ssl_certificate /etc/nginx/ssl/live/$host/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/live/$host/privkey.pem;

    location / {
        root /usr/share/nginx/html/;
    }

    location /api {
      rewrite ^/api/(.*)$ /$1  break;
    
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header Host $http_host;
      proxy_redirect off;
      proxy_pass http://api:5000;
    }

	location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    index index.php index.html index.htm;
    root /var/www/html;



}