# VestaCPWithNodeJS
Create custom template for NodeJS Application when using Nginx as reverse proxy on VestaCP with custom port, and deploy from github, with possibilite of .env file personal. For this you don't can modificaste originals bins. But you can modify template for personalize buttons for pull.

### Install Manual
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
5. Replace it with __v-change-web-domain-proxy-tpl__ provided in this repo. (I also provided my backup in this repo ___v-change-web-domain-proxy-tpl.old___)
3. Create file {DOMAIN}.port.conf in domain's conf folder, change {DOMAIN} with your domain
4. add this line into {DOMAIN}.port.conf, change {PORT} with your desired port
```bash
nodejs_port={PORT}
```
6. run __/usr/local/vesta/bin/v-change-web-domain-proxy-tpl USER DOMAIN TEMPLATES__ 
7. or simply update domain proxy templates from VestaCP GUI and click SAVE 

### Example in my case
1. My domain is __cadaver.vm__ , my Port is __3000__ , and my username is __admin__
2. From step 3 Step-by-step, I created file __cadaver.vm.port.conf__ in __/home/admin/conf/web/__ (Full path : __/home/admin/conf/web/cadaver.vm.port.conf__)
3. __/home/admin/conf/web/cadaver.vm.port.conf__'s content is:
```bash
nodejs_port=3000
```
4. Done

### Note
- v-change-web-domain-proxy-tpl is VestaCP cli executed when VestaCP rebuild web proxy
- if VestaCP is updated (i.e. yum update), perhaps v-change-web-domain-proxy-tpl will be reverted to default one provided by Vesta, I can't confirm it yet but in case this happen you need to replace it again
