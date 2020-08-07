# VestaCPWithNodeJS
Create custom template for NodeJS Application when using Nginx as reverse proxy on VestaCP with custom port, and deploy from github, with possibilite of .env file personal. For this you don't can modificaste originals bins. But you can modify template for personalize buttons for pull.

## Manual Install
1. Copy bins __[v-pull-node](/bin/v-pull-node)__ and __[v-reload-node](/bin/v-reload-node)__ to /usr/local/vesta/bin
2.  You need to give permissions to the bins you copied above, run:
```bash
chmod 755 -R /usr/local/vesta/bin/v-pull-node && chmod 755 -R /usr/local/vesta/bin/v-reload-node
```
3. Copy files __[node.tpl](/model_nginx/node.tpl)__, __[node.stpl](/model_nginx/node.stpl)__, __[node.sh](/model_nginx/node.sh)__ and folder __[node](/model_nginx/node)__ into __/usr/local/vesta/data/templates/web/nginx/__
4.  You need to give permissions to the models you copied above, run:
```bash
chmod 755 -R /usr/local/vesta/data/templates/web/nginx/node*
```
5. Copy folders __[pull](/pull/node/index.php)__ and __[reload](/reload/node/index.php)__ into __/usr/local/vesta/web/__
6. Replace __/usr/local/vesta/web/templates/admin/list_web.html__ per __[list_web.html](/web/templates/admin/list_web.html)__
7. Replace __/usr/local/vesta/web/templates/user/list_web.html__ per __[list_web.html](/web/templates/user/list_web.html)__
8. You need install pm2 package, you can run:
```bash
npm install pm2 -global
```
or 
```bash
yarn add pm2 -global
```

___Obs.___ _For you can deploy from github, you repo need is public or you can put a key .ssh in your user of VestaCP._

## Start Application
1. Add your domain, in my example I use __marconwillian.dev__.
2. Crate a file config on __node.config__, Ex.: __/home/projetos/web/{domain}/node.config__, In my case __/home/projetos/web/marconwillian.dev/node.config__.
3. You can create 1 or more process in this file. You must leave all fields, even if blank, all paths must be terminated with __/__
4. My model is:
```bash
---
git=git@github.com:marconwillian/BeTheHero.git
path=BeTheHero/
has-env=yes
env-name-from=server.env
env-name-to=.env
pre=cd backend/ && yarn install
name=@bethehero/server
pwd=BeTheHero/backend/
script=src/server.js
port=3007
base-route=/

```
Or can put 2 ou more process too:
```bash
---
git=git@github.com:marconwillian/BeTheHero.git
path=BeTheHero/
has-env=yes
env-name-from=server.env
env-name-to=.env
pre=cd backend/ && yarn install
name=@bethehero/server
pwd=BeTheHero/backend/
script=src/server.js
port=3007
base-route=/
---
git=
path=
has-env=no
env-name-from=
env-name-to=
pre=cd frontend/ && yarn install
name=@bethehero/frontend
pwd=BeTheHero/frontend/
script=src/server.js
port=
base-route=
```

### Fields
- git | You can put a git url from public repo, or put a ssh git, but you need generate a ssh key for this user and put in your account.
- path | Folder when you can clone your repo.
- has-env | You can config a .env file? you need put __yes__ or __no__.
- env-name-from | If you can config a file .env, you can put a original file on __/home/{user}/web/{domain}/__ and put a nome of file here
- env-name-to | new name of file __.env__, normaly this file is create in pwn field.
- pre | Execute a bash code before you start a process, the folder default is a __pwd__ field.  
    - But you can put other subfolder, type: 
    ```bash
    pre=cd subfolder && yarn install
    ```
- name | Name of process for identify your process in pull and reload button.
- pwd | Default folder of application, this folder is in __/home/{user}/web/{domain}/public_node/__, 
    - Ex.: If you create your app on __/home/{user}/web/{domain}/public_node/myapp/__, in this field you need put only:
    ```bash
    pwd=myapp/
    ```
- script | Referent your folder of __pwd__ field, you need put the path of your script .js.
    - Ex.: If you create a script in folder __myapp/server/index.js__, and you put in field pwd __pwd=myapp/__, in this field you need put:
    ```bash
        script=server/index.js
    ```
- port | If you want to make this process visible in this domain, you have to define the port here, configuration, do not forget to use the same port in your code or use the env variable __process.env.PORT__
- base-route | To complement the port configuration, you have to define the basic route, type, you can config 2 process, first is on route __/__ and second is __/graphql__. In these cases, all access to __{domain}/__ will go to the process defined for this wheel, and access to __{domain}/graphql__ will go to the other process. Don't forget to leave the wheel already configured in your application. If you define basic routes in __/__ in your application, only the one defined here with __/__ will work.