# CNDP Website

## Build locally

The preferred option for testing and development is to use a jekyll container to build
and serve the site.

```
docker run --rm -v `pwd`:/srv/jekyll -p 4000:4000 -it jekyll/jekyll:builder bash
bash-5.0# jekyll serve
```

Use a web browser to navigate to your host http://host:4000

## References

* https://jekyllrb.com/
* https://getbootstrap.com/docs/5.0/getting-started/introduction/

## Overview

The site uses Jekyll to build static pages. The API documentation is built by doxygen
from the CNDP source code. The User Guide documentation is built by sphinx from the
CNDP doc/ sources. Bootstrap 5 is used to style the site.

## Updating API and User Guide

A script is provided *_update_docs.sh* to automatically generate the API and User Guides from the
most recent release. The API reference and User Guides add custom HTML for the navbar which
needs to be kept in sync with the main site's navbar in *_includes/navigation.html*.
