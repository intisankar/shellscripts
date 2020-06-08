# shellscripts
## # odoo_installation.sh provides installation of odoo12
 To INSTALL excute the folowing command ready things for you <br>
 This will suite you any ubuntu versions (Ubuntu 12/14/16/20) <br>
 sh odoo_installation.sh $ODOO_DB_USER <br>
 (eg) sh odoo_installation.sh odoo <br>
###### ``Installation setup Sucessfuly completed`` message the way of running server is your choice,
###### ``CHOICE 1: nohup`` style
 - cd /opt/odoo #change according your installation folder
 - nohup ./odoo-bin &
 - for viewing log file ==> tail -f nohup.out
######  
###### ``CHOICE 2: As a service`` style 
 - #Create a systemd unit called ``odoo-server`` to allow your application to behave as a service. Create a new file at /lib/systemd/system/odoo-server.service and add the following contents: 
 - vi /lib/systemd/system/odoo-server.service
 - paste code :
    <pre>[Unit]
    Description=Odoo Open Source ERP and CRM
    Requires=postgresql.service
    After=network.target postgresql.service

    [Service]
    Type=simple
    PermissionsStartOnly=true
    SyslogIdentifier=odoo-server
    User=odoo
    Group=odoo
    ExecStart=/opt/odoo/odoo-bin --config=/etc/odoo-server.conf --addons-path=/opt/odoo/addons/
    WorkingDirectory=/opt/odoo/
    StandardOutput=journal+console

    [Install]
    WantedBy=multi-user.target </pre>
 - **Change File Ownership and PermissionsPermalink**
 - Change the odoo-server service permissions and ownership so only root can write to it, while the odoo user will only be able to read and execute it.
 - #sudo chmod 755 /lib/systemd/system/odoo-server.service
 - #sudo chown root: /lib/systemd/system/odoo-server.service
###### 
###### ``CHOICE 3: Using pm2`` style
 - ``Installation of pm2 is`` https://www.vultr.com/docs/how-to-setup-pm2-on-ubuntu-16-04
 - pm2 start odoo.py --name "$newinstance_name" --max-memory-restart 1G -- -d $db --without-demo=all -c openerp-server.conf --logfile odoo.log
 - some useful commands
<pre>pm2 restat $PM2_ID
pm2 stop $PM2_ID
pm2 start $PM2_ID
pm2 list
pm2 ls</pre>
###### 
###### 

## # postgres_backup.sh provides backup the any postgres DB (specially for odoo DBs)
script it self having the instruction 
 ``To Run this, ``
 - **manually**
 - sh postgres_backup.sh
 - **I recommended for schedule backups use cron jobs**
 - crontab -e 
 - <p>paste this code <br>  0 17 * * * /home/ubuntu/postgres_backup.sh >> /home/ubuntu/log.log 2>&1</p>
###### 
###### 
