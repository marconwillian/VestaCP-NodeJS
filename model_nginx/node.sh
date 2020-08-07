#!/bin/bash

user=$1
domain=$2
ip=$3
home=$4
docroot=$5

nginx_file=$home/$user/conf/web/$domain.nginx.conf
nginx_tmp=$(mktemp)
nginx_file_ssh=$home/$user/conf/web/$domain.nginx.ssl.conf
nginx_tmp_ssh=$(mktemp)

base_domin=$home/$user/web/$domain
public_node=$base_domin/public_node
config_files=/usr/local/vesta/data/templates/web/nginx

function deployFromGithub(){
    if [ ! -f ${git[$1]} ]; then
        runuser -l $user -c "mkdir -p -- $public_node/${git_path[$1]} && git clone ${git[$1]} $public_node/${git_path[$1]}"
    fi
}

function genereteConfig(){
    this_port=${port[$1]}
    this_base_route=${base_route[$1]}
    if [ ! -f $this_port ]; then
        eval "echo \"$(cat $config_files/node/nodejs-proxy.tpl)\"" >> $nginx_tmp
        eval "echo \"$(cat $config_files/node/nodejs-proxy.stpl)\"" >> $nginx_tmp_ssh
    fi
}

function copyEnv(){
    if [ "${has_env[$1]}" == "yes" ]; then
        eval "echo \"$(cat $base_domin/${env_name_from[$1]})\"" > $public_node/${pwd_item[$1]}${env_name_to[$1]}
        chown -R $user:$user $public_node/${pwd_item[$1]}${env_name_to[$1]}
        chmod -R 755 $public_node/${pwd_item[$1]}${env_name_to[$1]}
    fi
}

function preExeculte(){
    if [ "${pre[$1]}" != "" ]; then
        runuser -l $user -c "cd $public_node/${pwd_item[$1]} && ${pre[$1]}"
    fi
}

function execulteProcess(){
    if [ "${pre[$1]}" != "" ]; then
        runuser -l $user -c "cd $public_node/${pwd_item[$1]} && NODE_ENV=production PORT=${port[$1]} pm2 start ${script[$1]} --name ${name[$1]} && pm2 save && pm2 startup"
    fi
}


config=$base_domin/node.config

if [ -f $config ]; then
    mapfile -t git < <(grep 'git=' $config  | awk -F "=" '{print $2 ; }')
    mapfile -t git_path < <(grep 'path=' $config  | awk -F "=" '{print $2 ; }')
    mapfile -t has_env < <(grep 'has-env=' $config  | awk -F "=" '{print $2 ; }')
    mapfile -t env_name_from < <(grep 'env-name-from=' $config  | awk -F "=" '{print $2 ; }')
    mapfile -t env_name_to < <(grep 'env-name-to=' $config  | awk -F "=" '{print $2 ; }')
    mapfile -t pre < <(grep 'pre=' $config  | awk -F "=" '{print $2 ; }')
    mapfile -t name < <(grep 'name=' $config  | awk -F "=" '{print $2 ; }')
    mapfile -t pwd_item < <(grep 'pwd=' $config  | awk -F "=" '{print $2 ; }')
    mapfile -t script < <(grep 'script=' $config  | awk -F "=" '{print $2 ; }')
    mapfile -t port < <(grep 'port=' $config  | awk -F "=" '{print $2 ; }')
    mapfile -t base_route < <(grep 'base-route=' $config  | awk -F "=" '{print $2 ; }')
else
    echo Arquivo de configuração não encotrado
    exit
fi

eval "echo \"$(cat $config_files/node/nodejs-start.tpl)\"" > $nginx_tmp
eval "echo \"$(cat $config_files/node/nodejs-start.stpl)\"" > $nginx_tmp_ssh

for i in "${!name[@]}"
do
    deployFromGithub $i
    genereteConfig $i
    copyEnv $i
    preExeculte $i
    execulteProcess $i
done

eval "echo \"$(cat $config_files/node/nodejs-end.tpl)\"" >> $nginx_tmp
eval "echo \"$(cat $config_files/node/nodejs-end.stpl)\"" >> $nginx_tmp_ssh

rm $nginx_file
rm $nginx_file_ssh

mv $nginx_tmp $nginx_file
mv $nginx_tmp_ssh $nginx_file_ssh

#projetos server.proffy.marconwillian.dev 173.249.35.223 /home
