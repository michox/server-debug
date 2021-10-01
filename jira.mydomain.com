server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    include snippets/ssl.conf;
    include snippets/ssl-params.conf;

    server_name jira.mydomain.com www.jira.mydomain.com;
    location / {
	proxy_set_header X-Forwarded-Host $host;
    	proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; 
	proxy_pass http://localhost:8080;
        client_max_body_size 10M;
    }

}

server {
    listen 80;
    listen [::]:80;

    server_name jira.mydomain.com www.jira.mydomain.com;

    return 302 https://$server_name$request_uri;
}
