# MySQL Archiver/Backupper for Docker and Giant Swarm

This tool allows you to periodically dump a MySQL database and store the dump to Amazon AWS S3.

There is a tutorial in the making. The link will be published here as soon as it's online.

## Contents of this repository

*  `Makefile`: This Makefile allows you to quickly execute some of the steps explained in the guide. Please adjust the variables in the top before you start.

* `Dockerfile`: The blueprint for your Docker image doing the MySQL backups.

* `swarm.json`: Blueprint for your application configuration. Adjust according to your needs.
