# Installation
In the Media application we will use

* Ruby and Ruby on Rails
* PostgreSQL as the database
* Devise for authentication
* Bower for front-end assets
* AngularJS
* Bootstrap for CSS

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

## Install Bower
Bower manages front-end assets like Bootstrap or AngularJS. To install Bower we
need install NodeJS which is probably already available. With NodeJS comes the
npm package manager. We can install NodeJS from the Ubuntu repository

    $ sudo apt-get install nodejs

To install Bower we do

    $ sudo npm install -g bower

This will install Bower in global mode (`-g`) and install it in 
`/usr/local/lib/node_modules/bower` which needs root access.

We also want to install `bower-rails` to interact with Bower on the command line
with Rake instead of using the Bower command line interface directly. So add to 
the Gemfile

    gem 'bower-rails'

and run

    $ bundle install

## Install Boostrap
To ease CSS styling we rely on the CSS library Bootstrap so we don't have to
write rarely any CSS. We can search for Bootstrap with Bower

    $ bower search bootstrap | grep -P "^\s*bootstrap"

    bootstrap git://github.com/twbs/bootstrap.git
    bootstrap-sass-official git://github.com/twbs/bootstrap-sass.git
    bootstrap-datepicker git://github.com/eternicode/bootstrap-datepicker.git
    bootstrap-select git://github.com/silviomoreto/bootstrap-select.git
    bootstrap-daterangepicker git://github.com/dangrossman/\
    bootstrap-daterangepicker.git
    bootstrap-timepicker git://github.com/jdewit/bootstrap-timepicker
    bootstrap-switch git://github.com/nostalgiaz/bootstrap-switch.git
    bootstrap-css git://github.com/jozefizso/bower-bootstrap-css.git
    bootstrap-multiselect git://github.com/davidstutz/bootstrap-multiselect.git
    bootstrap.css git://github.com/bowerjs/bootstrap.git
    bootstrap-datetimepicker git://github.com/tarruda/\
    bootstrap-datetimepicker.git
    bootstrap-modal git://github.com/jschr/bootstrap-modal.git
    bootstrap-tour git://github.com/sorich87/bootstrap-tour.git
    bootstrap-tagsinput git://github.com/TimSchlechter/bootstrap-tagsinput.git
    bootstrap-additions git://github.com/mgcrea/bootstrap-additions.git
    bootstrap-file-input git://github.com/grevory/bootstrap-file-input.git
    bootstrap-social git://github.com/lipis/bootstrap-social.git

As Rails is working with Sass we use the second one in the list and add it to a
file called `Bowerfile` analogous to the Gemfile

    asset 'bootstrap-sass-official

Now we run the Rake task to install Bower

    $ rake bower:install

In order Bootstrap is considered when Rails is creating `application.css` we 
need to tell it to include Bootstrap. This is done in 
`app/assets/stylesheets/application.css`

    /*
     *= require_tree .
     *= require_self
     *= require 'bootstrap-sass-official'
     */

In order to see the new Bootstrap styles we have to restart our Rails server.

## Install AngularJS
AngularJS is a JavaScript framework we want to utilize in our application which
is easier to use than pure JQuery.

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

# Install Devise
Devise is used for user authentication. To install it we add to the Gemfile

    gem 'devise'

and then we run

    $ bundle install
    $ rails g devise:install

This will provide some information

    Some setup you must do manually if you haven't yet: 

      1. Ensure you have defined default url options in your environments files.
         Here is an example of default_url_options appropriate for a development
         environment in config/environments/development.rb:

           config.action_mailer.default_url_options = { host: 'localhost', 
                                                        port: 3000 }

         In production, :host should be set to the actual host of your 
         application. 

      2. Ensure you have defined root_url to *something* in your 
         config/routes.rb.  

         For example:

           root to: "home#index"

      3. Ensure you have flash messages in 
         app/views/layouts/application.html.erb.  

         For example:

           <p class="notice"><%= notice %></p>
           <p class="alert"><%= alert %></p>

      4. If you are deploying on Heroku with Rails 3.2 only, you may want to 
         set:

           config.assets.initialize_on_precompile = false

         On config/application.rb forcing your application to not access the DB
         or load models when precompiling your assets.

      5. You can copy Devise views (for customization) to your app by running:

           rails g devise:views        

Devise comes with a generator for creating an user model. We will use that with

    $ rails g devise user

In order to restrict access to registered in logged in users only we have to add
the `authenticate_user!` filter, that comes with Devise, to the 
`ApplicationController`. Note that this will prevent access of anonymous users
on all Media pages. If we want to have pages we want to allow access to by
anonymous users we have to skip the filter in the respective controller or 
actions. For now we add `authenticate_user!` to the `ApplicationController`.

    before_action :authenticate_user!

We have to restart our Rails server in order to activate the changes.

    $ CTRL-C
    $ rails s

We can also view the database with

    $ rails dbconsole
    Password:

To enter the database console we have to enter the password we have provided in
`config/database.yml` for the media database.

