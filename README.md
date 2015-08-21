DokuWiki docker container
=========================

Note:
-------------
The majority of this Dockerfile was taken from mprasil/dokuwiki. Please use mprasil/dokuwiki, it's better. 
This version was modified to install some plugins and restore from a backup.

To install and build
-------------

    git clone git@github.com:jasonswat/dokuwiki.git
    cd docker_dokuwiki
    docker build -t jasonswat/dokuwiki --no-cache=false .

To run image:
-------------

    docker run -d -p 80:80 jasonswat/dokuwiki
