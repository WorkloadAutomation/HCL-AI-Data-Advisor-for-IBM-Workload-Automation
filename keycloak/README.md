## USE 443

- To use the 443 there is the need to change some parameters:
    1. change every **redirectUris** that are empty or equal to  **["/\*"]** to **["\*"]**
    2. comment the **hostname-port** inside the keycloak.conf
    3. inside the nginx/default.conf replace  **proxy_set_header X-Forwarded-Port  $requested_port;** to **proxy_set_header X-Forwarded-Port 443;** in **location /** and **location /keycloak**


## Create new certificate
```bash
openssl req -x509 -newkey rsa:4096 -keyout aida.key -out aida.crt -sha256 -days 3650 -nodes -subj "/C=XX/ST=US/L=NewYork/O=HCLSoftware/OU=AIDA/CN=<machine-ip>" && chmod 744 aida.key aida.crt
```
- replace inside Dockerfile-nginx the path of the old cert/key with the new one
