# Contact Importer

# Project software requirements:

* Ruby version: 2.7.2
* Rails version: 6.1
* Gemfile version: 3.1.4
* Bundler version: 2.2.15

## Starting

After pulling the project, a first execution of the bundler is needed
to download all the required libraries

```sh
bundle install
```

### Database:

The project is currently configured to run under MySql or MariaDB.
Teorically, you can use any other database, just some adjustments
will be required in the config/database.yml file.

### Credentials configuration:

The credentials are needed to connect the application to the database
in a secure way, do not store credentials directly on the database.yml
file, you can use the rails credentials editor or store it in 
your environment variables.

Additionaly, I've added the devise/pepper key to the credentials file.

### Generator

```sh
rails credentials:edit
```

## If you are using another console-based editor rather than default

Examples:

```sh
> EDITOR="nano" rails credentials:edit
> EDITOR="atom --wait" rails credentials:edit
> EDITOR="subl --wait" rails credentials:edit
> EDITOR="mate --wait" bin/rails credentials:edit
```

## Credentials example:
Format: yml
```sh
devise:
  pepper: ''
mysql:
  development:
    host: 'host'
    usr: 'username'
    pwd: 'password'
```

## Next steps:

After the database connection, is needed to create, migrate and seed the database:

```sh
>  rails db:create
>  rails db:migrate
>  rails db:seed
```

If you has already tested the database integrity, you can just run a setup for fast configuration

```sh
>  rails db:setup
```

For fast database reset

```sh
>  rails db:reset
```