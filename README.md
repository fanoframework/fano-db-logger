# Logger that log messages to MySQL database

Example Fano Framework web application to demonstrate logging message to MySQL database.

This project is generated using [Fano CLI](https://github.com/fanoframework/fano-cli)
command line tools to help scaffolding web application using Fano Framework.

## Requirement

- [Free Pascal](https://www.freepascal.org/) >= 3.0
- Web Server (Apache, nginx)
- [Fano Web Framework](https://github.com/fanoframework/fano)

## Installation

### TL;DR

```
$ git clone git@github.com:fanofamework/fano-db-logger.git --recursive
$ cd fano-db-logger
$ ./tools/config.setup.sh
$ ./build.sh
```

### Setup MySQL database

Before you run application, you need to setup database and table schema.
Run `tools/data.seeder.sh` from command line

```
$ DB_ADMIN=[root user] DB_USER=[user to be created] DB_PASSW=[password] ./tools/data.seeder.sh
```

Following command will prompt you to provide password for `root` and will setup
new user with name `fano-db-logger` and password `123456`, create database with
same name as user, i.e., `fano-db-logger`, and seed all data.

```
$ DB_ADMIN=root DB_USER=fano-db-logger DB_PASSW=123456 ./tools/data.seeder.sh
```

After that, you need put new database user credential to `src/config/config.json`.

### Run application

Deploy and run application

```
$ sudo fanocli --deploy-scgi=db-logger.fano
$ ./bin/app.cgi
```
Open Internet browser and visit URL http://db-logger.fano . You should see `Home Controller` text printed. Open your database manager tools and check, there should be a record added in table `logs` each time URL is visited.

### Build for different environment

To build for different environment, set `BUILD_TYPE` environment variable.

#### Build for production environment

    $ BUILD_TYPE=prod ./build.sh

Build process will use compiler configuration defined in `vendor/fano/fano.cfg`, `build.cfg` and `build.prod.cfg`. By default, `build.prod.cfg` contains some compiler switches that will aggressively optimize executable both in speed and size.

#### Build for development environment

    $ BUILD_TYPE=dev ./build.sh

Build process will use compiler configuration defined in `vendor/fano/fano.cfg`, `build.cfg` and `build.dev.cfg`.

If `BUILD_TYPE` environment variable is not set, production environment will be assumed.

## Change executable output directory

Compilation will output executable to directory defined in `EXEC_OUTPUT_DIR`
environment variable. By default is `public` directory.

    $ EXEC_OUTPUT_DIR=/path/to/public/dir ./build.sh

## Change executable name

Compilation will use executable filename as defined in `EXEC_OUTPUT_NAME`
environment variable. By default is `app.cgi` filename.

    $ EXEC_OUTPUT_NAME=index.cgi ./build.sh


## Run with a webserver

If you use Fano CLI to deploy, you can skip this part.

Setup a virtual host. Please consult documentation of web server you use.

### Apache

You need to have `mod_proxy_scgi` installed and loaded. This module is Apache's built-in module, so it is very likely that you will have it with your Apache installation. You just need to make sure it is loaded. For example, on Debian,

```
$ sudo a2enmod proxy_scgi
$ sudo systemctl restart apache2
```

Create virtual host config and add `ProxyPassMatch`, for example

```
<VirtualHost *:80>
     ServerName www.example.com
     DocumentRoot /home/example/public

     <Directory "/home/example/public">
         Options +ExecCGI
         AllowOverride FileInfo
         Require all granted
     </Directory>

    ProxyRequests Off
    ProxyPass /css !
    ProxyPass /images !
    ProxyPass /js !
    ProxyPassMatch ^/(.*)$ scgi://127.0.0.1:20477
</VirtualHost>
```
Last four line of virtual host configurations basically tell Apache to serve any
files inside `css`, `images`, `js` directly otherwise pass it to our application.

On Debian, save it to `/etc/apache2/sites-available` for example as `fano-db-logger.conf`
Enable this site and restart Apache

```
$ sudo a2ensite fano-db-logger.conf
$ sudo systemctl restart apache2
```

## Deployment

You need to deploy only executable binary and any supporting files such as HTML templates, images, css stylesheets, application config.
Any `pas` or `inc` files or shell scripts is not needed in deployment machine in order application to run.

So for this repository, you will need to copy `public`, `Templates`, `config`
and `storages` directories to your deployment machine. make sure that
`storages` directory is writable by web server.

## Known Issues

### Issue with GNU Linker

When running `build.sh` script, you may encounter following warning:

```
/usr/bin/ld: warning: public/link.res contains output sections; did you forget -T?
```

This is known issue between Free Pascal and GNU Linker. See
[FAQ: link.res syntax error, or "did you forget -T?"](https://www.freepascal.org/faq.var#unix-ld219)

However, this warning is minor and can be ignored. It does not affect output executable.

### Issue with unsynchronized compiled unit with unit source

Sometime Free Pascal can not compile your code because, for example, you deleted a
unit source code (.pas) but old generated unit (.ppu, .o, .a files) still there
or when you switch between git branches. Solution is to remove those files.

By default, generated compiled units are in `bin/unit` directory.
But do not delete `README.md` file inside this directory, as it is not being ignored by git.

```
$ rm bin/unit/*.ppu
$ rm bin/unit/*.o
$ rm bin/unit/*.rsj
$ rm bin/unit/*.a
```

Following shell command will remove all files inside `bin/unit` directory except
`README.md` file.

    $ find bin/unit ! -name 'README.md' -type f -exec rm -f {} +

`tools/clean.sh` script is provided to simplify this task.

### Windows user

Free Pascal supports Windows as target operating system, however, this repository is not yet tested on Windows. To target Windows, in `build.cfg` replace
compiler switch `-Tlinux` with `-Twin64` and uncomment line `#-WC` to
become `-WC`.

### Lazarus user

While you can use Lazarus IDE, it is not mandatory tool. Any text editor for code editing (Atom, Visual Studio Code, Sublime, Vim etc) should suffice.
