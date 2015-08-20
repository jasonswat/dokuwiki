DokuWiki docker container
=========================

Note:
-------------
The majority of this Dockerfile was taken from mprasil/dokuwiki. Please use mprasil/dokuwiki, it's better. 
This version was modified to install some plugins and restore from a backup.


To run image:
-------------

	docker run -d -p 80:80 --name my_wiki jasonswat/dokuwiki 
