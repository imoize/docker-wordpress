# Wordpress Docker Image

Minimal, Docker images for Wordpress. This image not include with web server and need seperate web server container.

[![Github Build Status](https://img.shields.io/github/actions/workflow/status/imoize/docker-wordpress/build.yml?color=458837&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=build&logo=github)](https://github.com/imoize/docker-wordpress/actions?workflow=build)
[![GitHub](https://img.shields.io/static/v1.svg?color=3C79F5&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=imoize&message=GitHub&logo=github)](https://github.com/imoize/docker-wordpress)
[![GitHub Package Repository](https://img.shields.io/static/v1.svg?color=3C79F5&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=imoize&message=GitHub%20Package&logo=github)](https://github.com/imoize/docker-wordpress/pkgs/container/wordpress)
[![Docker Pulls](https://img.shields.io/docker/pulls/imoize/wordpress.svg?color=3C79F5&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/imoize/wordpress)

## Supported Architectures

Multi-platform available trough docker manifest. Simply pulling using `latest` tag should retrieve the correct image for your arch.

The architectures supported by this image:

| Architecture | Available |
| :----: | :----: |
| x86-64 | ✅ |
| arm64 | ✅ |

## Usage

Here are some example to help you get started creating a container, easiest way to setup is using docker-compose or use docker cli.

- **docker-compose (recommended)**

```yaml
---
version: "3.9"
services:
  wordpress:
    image: imoize/wordpress:latest
    container_name: wordpress
    ports:
      - 9000:9000
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=Asia/Jakarta
      - WORDPRESS_DB_HOST=db
      - WORDPRESS_DB_NAME=wordpress
      - WORDPRESS_DB_USER=wordpress
      - WORDPRESS_DB_PASSWORD=wordpress
    volumes:
      - /path/to/app/data:/config
    restart: always
```

- **docker cli**

```bash
docker run -d \
  --name=wordpress \
  -p 9000:9000
  -e PUID=1001 \
  -e PGID=1001 \
  -e TZ=Asia/Jakarta \
  -e WORDPRESS_DB_HOST=db \
  -e WORDPRESS_DB_NAME=wordpress \
  -e WORDPRESS_DB_USER=wordpress \
  -e WORDPRESS_DB_PASSWORD=wordpress \
  -v /path/to/app/data:/config \
  --restart always \
  imoize/wordpress:latest
```

## Available environment variables:

| Name                      | Description                                            | Default Value |
| ------------------------- | ------------------------------------------------------ | ------------- |
| PUID                      | User UID                                               |               |
| PGID                      | Group GID                                              |               |
| TZ                        | Specify a timezone see this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List).       | UTC          |
| S6_VERBOSITY              | Controls the verbosity of s6-rc. See [this.](https://github.com/just-containers/s6-overlay?tab=readme-ov-file#customizing-s6-overlay-behaviour)    | 1             |
| BYPASS_DB_CHECK           | Bypass Database check before service start.            | no            |
| WORDPRESS_DB_HOST         | Define database hostname. Can use docker secret.               |               |
| WORDPRESS_DB_NAME         | Define database name. Can use docker secret.                   |               |
| WORDPRESS_DB_USER         | Define database user. Can use docker secret.                   |               |
| WORDPRESS_DB_PASSWORD     | Define database password. Can use docker secret.               |               |
| WORDPRESS_TABLE_PREFIX    | Define table prefix, you can change it. Can use docker secret. | wpx_          |
| MEMORY_LIMIT              | Set PHP Memory Limit.                                  | 256M          |
| MAX_INPUT_TIME            | Set PHP Maximum Input Time.                            | 600           |
| MAX_INPUT_VARS            | Set PHP Maximum Input Vars.                            | 5000          |
| MAX_FILE_UPLOADS          | Set PHP Maximum File can be Upload.                    | 20            |
| MAX_EXECUTION_TIME        | Set PHP Maximum Execution Time.                        | 600           |
| POST_MAX_SIZE             | Set PHP Maximum Post Size.                             | 16M           |
| UPLOAD_MAX_FILESIZE       | Set PHP Maximum Filesize can be Upload.                | 16M           |
| OPCACHE_ENABLE            | Set PHP Opcache enable or not.                         | true          |

## Configuration

### Environment variables

When you start the wordpress image, you can adjust the configuration of the instance by passing one or more environment variables either on the `docker-compose` file or on the `docker run` command line. Please note that some variables are only considered when the container is started for the first time. If you want to add a new environment variable:

- **for `docker-compose` add the variable name and value:**

```yaml
wordpress:
    ...
    environment:
      - PUID=1001
      - TZ=Asia/Jakarta
      - WORDPRESS_DB_HOST=db
      - WORDPRESS_DB_NAME=wordpress
      - WORDPRESS_DB_USER=wordpress
      - WORDPRESS_DB_PASSWORD=wordpress
      - BYPASS_DB_CHECK=yes
    ...
```

- **for manual execution add a `-e` option with each variable and value:**

```bash
  docker run -d \
  -e PUID=1001 \
  -e TZ=Asia/Jakarta \
  -e WORDPRESS_DB_HOST=db \
  -e WORDPRESS_DB_NAME=wordpress \
  -e WORDPRESS_DB_USER=wordpress \
  -e WORDPRESS_DB_PASSWORD=wordpress \
  -e BYPASS_DB_CHECK=yes \
  imoize/wordpress:latest
```

### Docker Secrets Support

You can append __FILE (double underscore) to WORDPRESS_DB_* env.

```yaml
services:
  wordpress:
      ...
      environment:
        - PUID=1001
        - WORDPRESS_DB_PASSWORD__FILE="/run/secrets/wordpress_password"
      secrets:
        - wordpress_password

secrets:
  wordpress_password:
    external: true
      ...
```

## Volume

### Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the data and config will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should map directory inside container in `/config` path to host directory as data volumes. Application state will persist as long as directory on the host are not removed.

**e.g:** `/path/to/app/data:/config`

```yaml
wordpress:
    ...
    environment:
      - PUID=1001
    volumes:
      - /path/to/app/data:/config
    ...
```

`/config` folder contains wordpress relevant configuration files.

## User / Group Identifiers

For example: `PUID=1001` and `PGID=1001`, to find yours user `id` and `gid` type `id <your_username>` in terminal.
```bash
  $ id your_username
    uid=1001(user) gid=1001(group) groups=1001(group)
```

## Contributing

We'd love for you to contribute to this container. You can submitting a [pull request](https://github.com/imoize/docker-wordpress/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can create an [issue](https://github.com/imoize/docker-wordpress/issues).