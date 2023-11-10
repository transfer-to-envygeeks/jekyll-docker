<!-- markdownlint-disable MD026 MD033 MD041 -->

<a href="https://jekyllrb.com" target="_blank" title="Jekyll">
<img src="http://jekyllrb.com/img/logo-2x.png" align="right" alt="Jekyll" height="100">
</a>

<!-- omit in toc -->
# Jekyll Docker

[![Docker Pulls](https://img.shields.io/docker/pulls/jvconseil/jekyll-docker?logo=docker)](https://hub.docker.com/r/jvconseil/jekyll-docker)
[![Docker Stars](https://img.shields.io/docker/stars/jvconseil/jekyll-docker?logo=docker&color=orange)](https://hub.docker.com/r/jvconseil/jekyll-docker)
[![Deploy](https://github.com/JV-conseil/jekyll-docker/actions/workflows/deploy.yml/badge.svg)](https://github.com/JV-conseil/jekyll-docker/actions/workflows/deploy.yml)
![visitors](https://visitor-badge.laobi.icu/badge?page_id=JV-conseil.jekyll-docker)
[![License EUPL 1.2](https://img.shields.io/badge/License-EUPL--1.2-blue.svg)](LICENSE)
[![Become a sponsor to JV-conseil](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/JV-conseil "Become a sponsor to JV-conseil")
[![Follow JV conseil on StackOverflow](https://img.shields.io/stackexchange/stackoverflow/r/2477854)](https://stackoverflow.com/users/2477854/jv-conseil "Follow JV conseil on StackOverflow")
[![Follow JVconseil on Twitter](https://img.shields.io/twitter/follow/JVconseil.svg?style=social&logo=twitter)](https://twitter.com/JVconseil "Follow JVconseil on Twitter")
[![Follow JVconseil on Mastodon](https://img.shields.io/mastodon/follow/110950122046692405)](https://mastodon.social/@JVconseil "Follow JVconseil@mastodon.social on Mastodon")
[![Follow JV conseil on GitHub](https://img.shields.io/github/followers/JV-conseil?label=JV-conseil&style=social)](https://github.com/JV-conseil "Follow JV-conseil on GitHub")

Jekyll Docker is a software image that has Jekyll and many of its dependencies ready to use for you in an encapsulated format. It includes a default set of gems, wrappers and extra packages meant to be used by people who are deploying their Jekyll builds to another server with a CI. If you would like to know more about Docker you can visit <https://docker.com>, and if you would like to know more about Jekyll, you can visit <https://github.com/jekyll/jekyll>

## Image Types

1. `jvconseil/jekyll-docker`: Includes tools.
2. <s>`jvconseil/jekyll`: Standard image.</s>
3. <s>`jvconseil/jekyll-minimal`: Very minimal image.</s>

### Builder

The builder image (`jvconseil/jekyll-docker`) comes with extra stuff that is not included in the standard image, like `lftp`, `openssh` and other extra packages meant to be used by people who are deploying their Jekyll builds to another server with a CI.

#### Usage

```sh
export JEKYLL_VERSION=4.3.2
docker run --rm \
  --volume="$PWD:/srv/jekyll:Z" \
  -it jvconseil/jekyll-docker:$JEKYLL_VERSION \
  jekyll build
```

### Standard (unsupported)

The standard images (`jvconseil/jekyll`) include a default set of "dev" packages, along with Node.js, and other stuff that makes Jekyll easy.  It also includes a bunch of default gems that the community wishes us to maintain on the image.

#### Usage

```sh
export JEKYLL_VERSION=4.3.2
docker run --rm \
  --volume="$PWD:/srv/jekyll:Z" \
  -it jvconseil/jekyll:$JEKYLL_VERSION \
  jekyll build
```

#### Quick start under Windows (cmd)

```cmd
set site_name=my-blog
docker run --rm --volume="%CD%:/srv/jekyll" -it jvconseil/jekyll sh -c "chown -R jekyll /usr/gem/ && jekyll new %site_name%" && cd %site_name%
```

#### Quick start under Linux / Git Bash

If you are under linux skip `export MSYS_NO_PATHCONV=1`. It is added for compatibility. You can check [here](https://github.com/docker-archive/toolbox/issues/673).

```sh
export site_name="my-blog" && export MSYS_NO_PATHCONV=1
docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  -it jvconseil/jekyll \
  sh -c "chown -R jekyll /usr/gem/ && jekyll new $site_name" \
  && cd $site_name
```

### Minimal (unsupported)

The minimal image (`jvconseil/jekyll-minimal`) skips all the extra gems, all the extra dev dependencies and leaves a very small image to download.  This is intended for people who do not need anything extra but Jekyll.

#### Usage

***You will need to provide a `.apk` file if you intend to use anything like Nokogiri or otherwise, we do not install any development headers or dependencies so C based gems will fail to install.***

```sh
export JEKYLL_VERSION=4.3.2
docker run --rm \
  --volume="$PWD:/srv/jekyll:Z" \
  -it jvconseil/jekyll-minimal:$JEKYLL_VERSION \
  jekyll build
```

#### Rootless Containers

If you are using a rootless container management system, you can set the `JEKYLL_ROOTLESS` environment variable to any non-zero value. For example, you can use the following to initialize a new jekyll project in the current directory using [`podman`](https://podman.io/).

```sh
podman run -ti --rm -v .:/srv/jekyll -e JEKYLL_ROOTLESS=1 docker.io/jvconseil/jekyll jekyll new .
```

## Server

For local development, Jekyll can be run in server mode inside the container. It will watch for changes, rebuild the site, and provide access through its included web server. You can then check the results of changes by reloading <http://localhost:4000/> in a browser.

#### Usage

```sh
docker run --rm \
  --volume="$PWD:/srv/jekyll:Z" \
  --publish [::1]:4000:4000 \
  jvconseil/jekyll \
  jekyll serve
```

## Dependencies

Jekyll Docker will attempt to install any dependencies that you list inside of your `Gemfile`, matching the versions you have in your `Gemfile.lock`, including Jekyll if you have a version that does not match the version of the image you are using (you should be doing `gem "jekyll", "~> 4.3.2"` so that minor versions are installed if you use say image tag "3.7.3").

### Updating

If you provide a `Gemfile` and would like to update your `Gemfile.lock` you can run

```sh
export JEKYLL_VERSION=4.3.2
docker run --rm \
  --volume="$PWD:/srv/jekyll:Z" \
  -it jvconseil/jekyll:$JEKYLL_VERSION \
  bundle update
```

### Caching

You can enable caching in Jekyll Docker by using a `docker --volume` that points to `/usr/local/bundle` inside of the image.  This is ideal for users who run builds on CI's and wish them to be fast.

#### My Gems Aren't Caching

***If you do not diverge from the default set of gems we provide (read: add Gems to your Gemfile that aren't already on the image), then bundler by default will not create duplicates, and cache.  It will simply rely on what is already installed in `$GEM_HOME`.  This is the default (observed... but unconfirmed) behavior of `bundle` when using `$GEM_HOME` w/ `$BUNDLE_HOME`***

### Usage

```sh
export JEKYLL_VERSION=4.3.2
docker run --rm \
  --volume="$PWD:/srv/jekyll:Z" \
  --volume="$PWD/vendor/bundle:/usr/local/bundle:Z" \
  -it jvconseil/jekyll:$JEKYLL_VERSION \
  jekyll build
```

***The root of the cache volume (in this case vendor) must also be excluded from the Jekyll build via the `_config.yml` exclude array setting.***

## Configuration

You can configure some pieces of Jekyll using environment variables, what you cannot with environment variables you can configure using the Jekyll CLI.  Even with a wrapper, we pass all arguments onto Jekyll when we finally call it.

| ENV Var         | Default |
| --------------- | ------- |
| `JEKYLL_UID`    | `1000`  |
| `JEKYLL_GID`    | `1000`  |
| `JEKYLL_DEBUG`, | `""`    |
| `VERBOSE`       | `""`    |
| `FORCE_POLLING` | `""`    |

If you would like to know the CLI options for Jekyll, you can visit [Jekyll's Help Site][2]

## Packages

You can install system packages by providing a file named `.apk` with one package per line.  If you need to find out what the package names are for a given command you wish to use you can visit <https://pkgs.alpinelinux.org>. ***We provide many dependencies for most Ruby stuff by default for `builder` and standard images.  This includes `ruby-dev`, `xml`, `xslt`, `git` and other stuff that most Ruby packages might need.***

## Credits

This Docker image is inspired by and builds on functionality in <https://github.com/envygeeks/jekyll-docker>, with both feature and version improvements.

## Sponsorship

If this project helps you, you can offer me a cup of coffee ☕️ :-)

[![Become a sponsor to JV-conseil](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/JV-conseil)

<!-- links -->

[2]: http://jekyllrb.com/docs/configuration/#build-command-options

