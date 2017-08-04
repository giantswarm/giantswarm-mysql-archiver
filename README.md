# MySQL Archiver/Backupper for Docker and Giant Swarm

**Note: This example is outdated, as it was written for a platform no longer offered by Giant Swarm.**

This tool allows you to periodically dump a MySQL database and store the dump to Amazon AWS S3. It is part of a larger tutorial:

[MySQL with Backups on Giant Swarm](https://firstgen-docs.giantswarm.io/guides/mysql-backup/)

## Contents of this repository

*  `Makefile`: This Makefile allows you to quickly execute some of the steps explained in the guide. Please adjust the variables in the top before you start.

* `Dockerfile`: The blueprint for your Docker image doing the MySQL backups.

* `swarm.json`: Blueprint for your service definition. Adjust according to your needs.
