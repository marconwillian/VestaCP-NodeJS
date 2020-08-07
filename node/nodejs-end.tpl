
    location /error/ {
        alias   ${home}/${user}/web/${domain}/document_errors/;
    }

    location @fallback {
        proxy_pass      http://${ip}:8080;
    }

    location ~ /\.env    {return 404;}
    location ~ /\.ht    {return 404;}
    location ~ /\.svn/  {return 404;}
    location ~ /\.git/  {return 404;}
    location ~ /\.hg/   {return 404;}
    location ~ /\.bzr/  {return 404;}

    include ${home}/${user}/conf/web/nginx.${domain}.conf*;
}
