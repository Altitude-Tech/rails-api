# Production setup
*This setup assumes use of Ubuntu 14.04.*

## Requirements
To start, install [RVM](https://rvm.io/rvm/install) and then install and select Ruby v2.3.0:
```
$ rvm install ruby-2.3.0
$ rvm use ruby-2.3.0
```
Verify with `$ rvm list`.

Next, install bundler:
```
gem install bundler -v '~> 1.12'
```

Then, install MySQL for the database:
```
$ sudo apt-get install mysql-server mysql-client libmysqlclient-dev
```

Finally, install the required gems with bundler:
```
$ bundle install
```

## Configuration
### Database
*TODO: add in initial database setup*

To create the database user, run the following from the MySQL command line substituting in the required values:
```
> CREATE USER '<API_DATABASE_USER>'@'localhost' IDENTIFIED BY '<API_DATABASE_PASSWORD>';
> GRANT Select,Insert,Update,Delete,Lock Tables ON api_production.* TO '<API_DATABASE_USER>'@'localhost';
> FLUSH PRIVILEGES;
```

This user will only work for normal operations, another user with admin permissions can be used for database creation/setup:
```
> CREATE USER '<API_DATABASE_ADMIN>'@'localhost' IDENTIFIED BY '<API_DATABASE_ADMIN_PASSWORD>';
> RANT Select,Insert,Update,Delete,Create,Drop,Index,Alter,Lock Tables ON api_production.* TO '<API_DATABASE_ADMIN>'@'localhost';
> FLUSH PRIVILEGES;
```

### Environment variables
The following environment variables need to be set:
* `SECRET_KEY_BASE` - Set to the result of `$ rake secret`.
* `API_DATABASE_USER` - The name of the user with access to normal operations.
* `API_DATABASE_PASSWORD` - The password of the user set in `API_DATABASE_USER`.
* `API_DATBASE_ADMIN` - The name of the user with admin access to the database.
* `API_DATABASE_ADMIN_PASSWORD` - The password of the user set in `API_DATABASE_ADMIN`.

These variables should be set in `.version.conf`. A sample configuration can be found in `.version.conf.sample` which can be copied an edited as required:
```
$ cp .version.conf.sample .version.conf
$ nano .version.conf
# and set the variables required, prefixed with "env-"
```
All other variables in the sample file should be left unaltered.

### Puma
Puma will be used as the web server, which requires a small amount of setup.

Firstly, copy `setup/puma.conf` and `setup/puma-manager.conf` to `/etc/init/`:
```
$ sudo cp setup/puma.conf setup/puma-manager.conf /etc/init
```

To verify this works correctly, run:
```
$ sudo start puma app=/path/to/api
$ sudo status puma app=/path/to/api
$ sudo stop puma app=/path/to/api
```
Double check the log at `/var/log/upstart/puma-_path_to_api` for any errors.

Puma-manager can use a list of apps to run upon, set with `/etc/puma.conf`. To configure it run:
```
$ sudo nano /etc/puma.conf
```
Then add the path to the api directory and before saving the file:
```
/path/to/api
```

Verify this works correctly with:
```
$ sudo start puma-manager
$ sudo stop puma-manager
```
Again, check the logs for any errors.

### Nginx
Nginx will be used as a reverse proxy server. Install it with:
```
$ sudo apt-get install nginx
```

There is a sample config at `setup/api-nginx.conf` which should be copied to `/etc/nginx/sites-available/`:
```
$ sudo cp setup/api-nginx.conf /etc/nginx/sites-available
```

You'll need to alter the `server_name` for the server block to your IP or domain and the `server` for the upstream api block to the correct directory.

Next, add symbolic link to `/etc/nginx/sites-enabled`:
```
$ cd  /etc/nginx/sites-enabled
$ sudo ln -s /etc/nginx/sites-enabled/api-nginx.conf api-nginx.conf
```

Finally, start up puma-manager and nginx:
```
$ sudo start puma-manager
$ sudo restart nginx
```
