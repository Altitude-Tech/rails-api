# README

## Requirements
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
Ensure the user account as defined in `config/database.yml` exists first. For production, both user and password are set via environment variables, so ensure the user exists and the variables have been set accordingly.

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