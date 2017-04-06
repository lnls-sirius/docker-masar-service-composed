# Docker Compose for MASAR service

## Running instructions

	docker network create dockerrbacauthservicescomposed_postgres-rbac

Setup network

	docker-compose up -d

## Systemd Integration

To integrate this as a systemd service, do:

    make install

To remove the systemd service and its additional files:

    make uninstall
