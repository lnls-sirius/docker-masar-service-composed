PREFIX ?= /usr/local
# This INIT_FILES_PREFIX could be different than PREFIX, as INIT_FILES_PREFIX
# is defined as the location of init scripts and must be placed in a specific
# place. The main use of this variable is for testing the build system
INIT_FILES_PREFIX ?=

CMDSEP = ;

PWD = 		$(shell pwd)
MKDIR =     mkdir
RMDIR =     rmdir
CP =        cp
INSTALL =   install
RM =        rm

INIT_SYSTEM := systemd

# Docker files
SRC_DOCKER_COMPOSE_FILE = docker-compose.yml
SERVICE_NAME = docker-masar-service-composed
TARGET_DOCKER_COMPOSE_FILE = ${SERVICE_NAME}.yml
DOCKER_FILES_DEST = ${PREFIX}/etc/${SERVICE_NAME}
DOCKER_FILES_ENV_FULL_NAME := $(shell find env-vars/ -type f)
DOCKER_FILES_COMPOSE_FULL_NAME := docker-compose.yml
DOCKER_FILES_FULL_NAME := ${DOCKER_FILES_COMPOSE_FULL_NAME} ${DOCKER_FILES_ENV_FULL_NAME}
# Strip off a leading ./
DOCKER_FILES=$(DOCKER_FILES_FULL_NAME:./%=%)

# Script files
INIT_FILES_FULL_NAME := $(shell cd ${INIT_SYSTEM} && find . -type f)
# Strip off a leading ./
INIT_FILES=$(INIT_FILES_FULL_NAME:./%=%)

.PHONY: all clean mrproper install uninstall

all:

install:
	${MKDIR} -p ${DOCKER_FILES_DEST}
	$(foreach dockerfile,$(DOCKER_FILES),cp --preserve=mode --parents $(dockerfile) ${DOCKER_FILES_DEST}/ $(CMDSEP))
	$(foreach script,$(INIT_FILES),cp --preserve=mode ${INIT_SYSTEM}/$(script) ${INIT_FILES_PREFIX}/$(script) $(CMDSEP))
	-./scripts/enable-service.sh -s $(SERVICE_NAME)

uninstall:
	-./scripts/disable-service.sh -s $(SERVICE_NAME)
	-$(foreach script,$(INIT_FILES),rm -f ${INIT_FILES_PREFIX}/$(script) $(CMDSEP))
	$(foreach dockerfile,$(DOCKER_FILES),rm -f ${DOCKER_FILES_DEST}/$(dockerfile) $(CMDSEP))
	-${RMDIR} ${DOCKER_FILES_DEST}

clean:

mrproper: clean
