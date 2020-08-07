server {
    listen      ${ip}:80;
    server_name ${domain};
    error_log  /var/log/httpd/domains/${domain}.error.log error;
 
