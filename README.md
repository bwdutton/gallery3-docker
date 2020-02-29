A gallery3 container running PHP 7.3 and MariaDB 10.

Here is a sample [docker-compose.yml](https://github.com/bwdutton/gallery3-docker/blob/master/docker-compose.yml). Copy this file to your server and edit the variables if you choose to:
* MYSQL_ROOT_PASSWORD=myrootpw
* MYSQL_DATABASE=gallery3
* MYSQL_USER=gallery3
* MYSQL_PASSWORD=mygallery3pw

Optional settings for CLI installation. Set these in the gallery container in addition to the above:
* DB_PREFIX - set this if you want your tablenames prefixes with a value, e.g. "g3_", defaults to blank
* G3_PASSWORD - set this to a specific admin password, otherwise one will be generated for you

When you start a new gallery installation, in addition to the above, you'll also have to enter the database host which is **mysql**. Once your settings are ready run __docker-compose__.

### HTTP Installer

Go to http://yourhostname, enter the values from the settings above and you should be all set.

### CLI Installer

This will run the installer from the command line and use the variables defined above:

> docker container exec -it gallery3docker_gallery3_1 php installer/index.php

If you didn't define a default admin password note your randomly generated password.
