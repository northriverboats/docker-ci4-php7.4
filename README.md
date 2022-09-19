CodeIgniter 4 on Apache with PHP 7.4
====
Instructions for building and using codeignter 4 in docker for development.  

## Extensions
An extension can be part of the base php container but not enabled by default. An extension can also be built with `pecl install`  or `docker-php-ext-install`. To enable an extension you can use `a2enmod` or `docker-php-ext-enable` with the later form being perfered.  

## Building
```
docker build . -t nrb/php7.4-apache
```

## Customizations
The `www-data` user has been changed from `33` to `1000` to take advantage of this fact the container should have the following `environment` variables:
```
    environment:
      - APACHE_RUN_USER="#1000"
      - APACHE_RUN_GROUP="#1000"
```
The default data directory has been set to `/var/www/public`  

To fully take advatage this setup:

- Makes sure Apache runs as user/group 1000  
- Makes sure container runs as user/group 1000  
- CodeIgntier is installed into `/var/www` with `/var/www/public` being exposed.  

## CodeIgniter Routing
Since Code Igniter 4.2  Auto Routing (Legacy)[Auto Routing (Legacy)](https://codeigniter4.github.io/CodeIgniter4/incoming/routing.html#auto-routing-legacy)  has been disabled.  There is only one route defined `/` routes to `Home::index`. There are three options:  

- Enable [Auto Routing (Legacy)](https://codeigniter4.github.io/CodeIgniter4/incoming/routing.html#auto-routing-legacy)  
- Enable [Auto Routing (Improved)](https://codeigniter4.github.io/CodeIgniter4/incoming/routing.html#auto-routing-improved)  
- Set [Routing Rules](https://codeigniter4.github.io/CodeIgniter4/incoming/routing.html#setting-routing-rules)  

Standard Routing Rules expect a verb and URI as well as a target controller:  
```
// Calls $Users->list()
$routes->get('users', 'Users::list');
```
Or can handle multiple verbs:
```
$routes->match(['get', 'put'], 'products', 'Product::feature');

```

## How To Setup a New Container
```
# install CodeIgniter4
docker-compose run ci4 composer create-project codeigniter4/appstarter app

# chanege ./ to ./app/
sed -i "s/- .\/:\/var\/www/- .\/app:\/var\/www/g" docker-compose.yml

# set ci4 environment for testing
sed -z "s/# app.baseURL = ''/app.baseURL = 'https:\/\/will.northriverboats.com'/2" app/env > app/.env
sed -i "s/# CI_ENVIRONMENT = production/CI_ENVIRONMENT = development/g" app/.env
```
