# README

## Requirements
* [RVM](https://rvm.io/rvm/install)
* Ruby v2.2.5+
* MySQL v5.5+ or MariaDB v10.0+¹
* Bundler v1.12+

¹ If using MariaDB, use Ruby v2.3.0+.

## Installation
Note that the `mysql2` gem used has additional dependencies in order to work correctly.

For Ubuntu/LinuxMint:
```
$ sudo apt-get install mysql-server mysql-client libmysqlclient-dev
```

For CentOS/RHEL/Fedora:
```
$ yum install mariadb-server mariadb-devel

```

For Fedora 22+
```
$ dnf install mariadb-server mariadb-devel
```

For Windows, you can download [MySQL Workbench](https://www.mysql.com/products/workbench/)


To install all remaining dependencies:
```
$ bundle install
```

## Database setup
Ensure the user account as defined in `config/database.yml` exists first. For production, both user and password are set via environment variables, so ensure the user exists and the variables have been set accordingly. See [Production setup](#Production setup) for more details.

To setup the database and all required tables:
```
$ rake db:create
$ rake db:migrate
```

For production:
```
$ RAILS_ENV=production rake db:create
$ RAILS_ENV=production rake db:migrate
```

## Tests
To run the test suite:
```
$ rake test
```

## Production setup
*This setup assumes use of Ubuntu 14.04.*

The following environment variables must be set in production:
* `RAILS_ENV` - should be set to `"production"`.
* `SECRET_KEY_BASE` - should be set to the result of `$ rake secret`.
* `API_DATABASE_USER` - should be set to the name of a user with access to the database.
* `API_DATABASE_PASSWORD` - should be set to the password of the user set in `API_DATABASE_USER`.

Add these variables to `~/.bash_profile`, log out and log back in. Ensure they have been set correctly with:
```
$ echo $RAILS_ENV
$ echo $SECRET_KEY_BASE

# etc.
```

To create the database account, run the following from the MySQL command line substituting in the required values:
```
CREATE USER '<API_DATABASE_USER>'@'localhost' IDENTIFIED BY '<API_DATABASE_PASSWORD>';
GRANT Select,Insert,Update,Delete,Lock Tables ON api_production.* TO '<API_DATABASE_USER>'@'localhost';

FLUSH PRIVILEGES;
```

