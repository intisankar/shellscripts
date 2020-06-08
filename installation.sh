#---------------------------------------------------
# excute the folowing command to do the things
# sh installation.sh $ODOO_DB_USER 
#--------------------------------------------------
echo "Installation setup Started!!! "
echo "---------------------------------"
sudo apt-get update
sudo apt-get -y upgrade
echo "---------------------------------"
echo "Configure UFW Firewall for Odoo"
echo "---------------------------------"
sudo ufw allow ssh
sudo ufw allow 8069/tcp
sudo ufw alloow 22
#sudo ufw enable
echo "---------------------------------"
echo "Install PostgreSQL Database and Server Dependencies"
echo "---------------------------------"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.list'
sudo apt-get -y update
sudo apt-get install postgresql-10 -y
sudo apt autoremove -y
sudo apt install git python3-pip build-essential wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less -y

echo "---------------------------------"
echo "DB user roles granting..."
echo "---------------------------------"
db_user=$1;
sudo -u postgres bash -c "createuser $db_user"
sudo -u postgres bash -c "psql -c \"ALTER USER $db_user WITH PASSWORD 'hu8jmn3';\""
sudo -u postgres bash -c "psql -c \"ALTER USER $db_user NOCREATEROLE NOSUPERUSER CREATEDB;\""
echo "---------------------------------"
echo "Create an Odoo User"
echo "---------------------------------"
sudo adduser --system --home=/opt/odoo --group odoo
sudo mkdir /var/log/odoo
echo "---------------------------------"
echo "cloning odoo"
echo "---------------------------------"
sudo git clone https://www.github.com/odoo/odoo --depth 1 --branch 12.0 --single-branch /opt/odoo
echo "---------------------------------"
echo "Install Python Dependencies"
echo "---------------------------------"
sudo pip3 install -r /opt/odoo/doc/requirements.txt
sudo pip3 install -r /opt/odoo/requirements.txt
echo "---------------------------------"
echo "Install Less CSS via Node.js and npm"
echo "---------------------------------"
sudo apt-install curl -y
sudo curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt install -y nodejs
sudo apt-get install npm -y
sudo npm install -g less less-plugin-clean-css
sudo apt-get install node-less
sudo pip3 install libsass
echo "---------------------------------"
echo "Install Stable Wkhtmltopdf Version"
echo "---------------------------------"
cd /tmp
sudo wget https://builds.wkhtmltopdf.org/0.12.1.3/wkhtmltox_0.12.1.3-1~$(lsb_release -sc)_amd64.deb
sudo apt install ./wkhtmltox_0.12.1.3-1~$(lsb_release -sc)_amd64.deb -y
sudo cp /usr/local/bin/wkhtmltoimage /usr/bin/wkhtmltoimage
sudo cp /usr/local/bin/wkhtmltopdf /usr/bin/wkhtmltopdf
sudo rm wkhtmltox_0.12.1.3-1~$(lsb_release -sc)_amd64.d*
cd ..

sudo cp /opt/odoo/debian/odoo.conf /etc/odoo-server.conf
echo "---------------------------------"
echo "creating conf file@@@@@@"
echo "---------------------------------"
file="/etc/odoo-server.conf"
echo "[options]"> $file
echo "admin_passwd = admin">> $file
echo "db_host = False" >> $file
echo "db_port = False" >> $file
echo "db_user = odoo" >> $file
echo "db_password = FALSE ">> $file
echo "addons_path = /opt/odoo/addons ">> $file
echo ";Uncomment the following line to enable a custom log ">> $file
echo "logfile = /var/log/odoo/odoo-server.log ">> $file
echo "xmlrpc_port = 8069 ">> $file
echo "-------------------------------"
echo "odoo-server config file is created!.."
echo "---------------------------------"
cat $file

#sudo npm install pm2 -g
#echo "pm2 cof is completd"
#cd /opt/odoo/
#pm2 start odoo-bin.py --name "odoo12"

echo "Installation setup Sucessfuly completed!!! "
echo "--------**--##---##---**-----------------"
