## Introduction

This docker image contains an [NGINX web server](https://github.com/nginx/nginx) configured with a builtin [LDAP authentification module](https://github.com/kvspb/nginx-auth-ldap).

It was shamelessly copied/inspired from [h3nrik/nginx-ldap image](https://github.com/g17/nginx-ldap/).

The main differences are:

- newer version
- does not use dockerize to launch nginx
- add an alternate default configuration file, inspired from the official NGINX image

The doc from the [h3nrik/nginx-ldap image](https://github.com/g17/nginx-ldap/) is valid for this image.
