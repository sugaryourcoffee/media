# Installation
In the Media application we will use

* Ruby and Ruby on Rails
* PostgreSQL
* AngularJS
* Bootstrap

## Install latest Ruby and Rails
First we make sure we have the latest RVM version

    $ rvm get stable

Then we check for the latest Ruby version

    $ rvm list known
    [ruby-]2.2

We install Ruby 2.2

    $ rvm install 2.2

and select it

    $ rvm ruby-2.2

Next we want to install the latest Rails version. We first check the Rails
versions available

    $ gem list ^rails$ -ra
    rails (4.2.5, 4.2.4, ...)

We create a gemset where we want to install Rails to

    $ rvm create gemset rails425
    $ rvm ruby-2.2.4@rails425
    $ gem install rails --no-ri --no-rdoc

Without providing an explicit version `gem install rails` will install the 
latest Rails version.

## Install PostgreSQL
In the application we want to use PostgreSQL as the database. We check if it 
is installed and which version is installed. We also want to have the latest
version here. To look up the latest version of PostgreSQL we go to 
[http://www.postgresql.org](http://www.postgresql.org). There it reads by the
time of this writing version 9.4. If we search in our version of Ubuntu 14.04LTS
we get the version 9.3.

    $ sudo apt-cache search postgresql-9
    postgresql-9.3 - object-relational SQL database, version 9.3 server

In order to install version 9.4 we may add the postgresql repository. How to do
that can be also found at [Linux downloads (Ubuntu)](http://www.postgresql.org/download/linux/ubuntu/)
and background about adding repostitories is described at [Repositories/CommandLine](https://help.ubuntu.com/community/Repositories/CommandLine).

Add following to `/etc/apt/sources.list.d/pgdg.list`

    deb http://apt.postgres.org/pub/repos/apt/ trusty-pddg main

Import the repository signing-key

    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -

Then update the package list, look for postgres-9.4 and install

    $ sudo apt-get update
    $ sudo apt-cache search postgres-9.4
    $ sudo apt-get install postgres-9.4 postgresql-contrib-9.4 \
    postgresql-server-dev-9.4

`postgresql-server-dev-9.4` is needed during the generation of our Rails 
applicaton.

As a first step we need to set the password
(see also [PostgreSQL Ubuntu Wiki](https://help.ubuntu.com/community/PostgreSQL)
for the *postgres* user.

    $ sudo -u postgres psql postgres
    postgres=# \password postgres
    Enter new password:
    Enter it again:
    postgres=# \q

In order we can access postgresql from Rails we will create a media user with a
password.

    $ sudo -u postgres psql postgres
    postgres=# CREATE ROLE media LOGIN PASSWORD 'secret' CREATEDB;
    CRATE ROLE
    postgres=# \q


This command will create a role *media* that is allowed to create databases 
`CREATEDB` and `LOGIN` will tell postgres that the user is allowed to login to 
the database.

## Install AngularJS
AngularJS is a JavaScript framework we want to utilize in our application which
is easier to use than pure JQuery.

## Install Boostrap
To ease CSS styling we rely on the CSS library Bootstrap.

# Craete the Media application
We create the application without ri and rdoc. We also don't want to use 
sprocket in favor of AngularJS.

    $ rails new media --skip-turbolinks \
                      --skip-spring \
                      --skip-test-unit \
                      -d postgresql

Now we change directory to our newly created media application directory.

##Configure config/database.yml
In order to create and access PostgreSQL database we need to add the username
and password to `config/database.yml`.

    default: &default
      adapter: postgresql
      encoding: unicode
      host: localhost
      username: media
      password: secret
      pool: 5

Next we create the database with

    $ rake db:create
    $ rake db:migrate

then start your Rails server

    $ rails s

and goto [http://localhost:3000](http://localhost:3000) where you should see
the default Rails welcome screen.

