# Please adjust the variables in the top
# according to your needs

# Name for the Docker image
PROJECT = mysql-archiver

# Registry server name
REGISTRY = registry.giantswarm.io

# Namespace string for your Docker image. 
# The easiest is to use your Giant Swarm username.
COMPANY :=  $(shell swarm user)

# Credentials of the AWS identity pushing backups to S3
AWS_ACCESS_KEY_ID = YOUR_KEY_ID
AWS_SECRET_ACCESS_KEY = YOUR_SECRET_ACCESS_KEY

# Ideally this is the region of your S3 bucket
AWS_DEFAULT_REGION = eu-central-1

# Name of your S3 bucket and optionally subfolder path
S3_BUCKET = yourbucket/yourfolder

# MySQL root password
MYSQL_ROOT_PASSWORD = rootpwd

# MySQL database name
MYSQL_DB_NAME = mydb


# Build the Docker image for our MySQL archiver
build:
	docker build -t $(REGISTRY)/$(COMPANY)/$(PROJECT) .

# Run a MySQL server locally for test purposes
run-local-mysql:
	docker run -d --name=mysql \
		-e MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) \
		-e MYSQL_DATABASE=$(MYSQL_DB_NAME) \
		mysql:5.5

# Run the mysql-archiver locally for test purposes
run-local-archiver:
	docker run --rm -ti \
		-e "AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)" \
		-e "AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)" \
		-e "AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION)" \
		-e "S3_BUCKET=$(S3_BUCKET)" \
		-e "BACKUP_INTERVAL=60" \
		-e "DB_NAME=$(MYSQL_DB_NAME)" \
		-e "DB_USER=root" \
		-e "DB_PASSWORD=$(MYSQL_ROOT_PASSWORD)" \
		-e "PATH_DATEPATTERN=%Y/%m" \
		--link mysql:mysql \
		$(REGISTRY)/$(COMPANY)/$(PROJECT)

# Push the Docker image to the Giant Swarm registry
# (be sure to do "docker login https://registry.giantswarm.io" first)
push:
	docker push $(REGISTRY)/$(COMPANY)/$(PROJECT)

# Get the image from the Giant Swarm registry, in case you
# have deleted your local copy and don't want to build it again
pull:
	docker pull $(REGISTRY)/$(COMPANY)/$(PROJECT)

# Create your application on Giant Swarm and start it
deploy:
	swarm up \
	  --var=mysqldb=$(MYSQL_DB_NAME) \
	  --var=mysqlpasswd=$(MYSQL_ROOT_PASSWORD)
