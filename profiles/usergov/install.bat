@echo Reseting IIS...
@iisreset
@sqlcmd -S (local) -E -i "C:\inetpub\DrupalDev\profiles\demo\db.mssql.sql" -v DatabaseName="drupal-dev7" LoginName="drupal_admin" LoginPassword="M00nshine" DatabasePath=""
@cd C:\inetpub\DrupalDev
@IF EXIST sites/default/settings.php @ATTRIB -R sites/default/settings.php
@drush -y si demo --db-url=sqlsrv://drupal_admin:M00nshine@(local):/drupal-dev7 --account-name=admin --account-mail=meloks@yahoo.com --account-pass=Password1234 --site-mail="admin@company.com" --site-name="D7 Demo" install_configure_form.site_default_country=GB install_configure_form.date_default_timezone="Europe/London"