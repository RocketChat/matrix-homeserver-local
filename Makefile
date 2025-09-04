.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Setup commands:"
	@echo "  make setup           - Run all initial setup steps (Root CA install and hosts update, recommended)"
	@echo "  make install-root-ca - Install Root CA depending on OS"
	@echo "  make apply-hosts     - Add missing entries from project hosts file to /etc/hosts (shows green for added, gray for existing, yellow alert if sudo required)"
	@echo "\nManagement commands:"
	@echo "  make clean-sqlite    - Remove SQLite data files (hs1 and hs2)"
	@echo "  make clean-mongo     - Remove MongoDB data"
	@echo "  make clean-all       - Run all cleanup commands"
	@echo "  make create-user-hs1 - Create admin user in hs1"
	@echo "  make create-user-hs2 - Create admin user in hs2"
	@echo "  make create-users-hs - Create admin users in hs1 and hs2"

# Install Root CA depending on OS
.PHONY: install-root-ca
install-root-ca:
	@if [ "$(shell uname)" = "Darwin" ]; then \
		if security find-certificate -c "mkcert rocketchat" /Library/Keychains/System.keychain > /dev/null 2>&1; then \
			printf "\033[0;32mRoot CA is already installed on MacOS.\033[0m\n"; \
		else \
			echo "Installing Root CA on MacOS..."; \
			sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain traefik/certs/ca/rootCA.crt; \
		fi; \
	elif [ "$(shell uname)" = "Linux" ]; then \
		if [ -f /usr/local/share/ca-certificates/rootCA.crt ] || [ -f /etc/ssl/certs/rootCA.pem ]; then \
			printf "\033[0;32mRoot CA is already installed on Linux.\033[0m\n"; \
		else \
			echo "Installing Root CA on Linux..."; \
			sudo cp traefik/certs/ca/rootCA.crt /usr/local/share/ca-certificates/rootCA.crt; \
			sudo update-ca-certificates; \
		fi; \
	else \
		echo "Unsupported OS. Please install the Root CA manually."; \
	fi

# Apply entries from the hosts file to the machine's /etc/hosts
.PHONY: apply-hosts
apply-hosts:
	@printf "\033[0;33m+-------------------------------------------------+\033[0m\n"
	@printf "\033[0;33m| May require sudo permissions to edit /etc/hosts |\033[0m\n"
	@printf "\033[0;33m+-------------------------------------------------+\033[0m\n"
	@echo ""

	@while read -r line; do \
		if ! grep -Fxq "$$line" /etc/hosts; then \
			echo "$$line" | sudo tee -a /etc/hosts > /dev/null; \
			printf "\033[0;32mAdded:          %s\033[0m\n" "$$line"; \
		else \
			printf "\033[0;90mAlready exists: %s\033[0m\n" "$$line"; \
		fi; \
	done < hosts

# Remove SQLite data files (hs1 and hs2)
.PHONY: clean-sqlite
clean-sqlite:
	rm -rf hs1/*.db hs1/*.db-* hs1/media_store
	rm -rf hs2/*.db hs2/*.db-* hs2/media_store

# Remove MongoDB data
.PHONY: clean-mongo
clean-mongo:
	rm -rf mongodb/data

# Run all cleanup commands
.PHONY: clean-all
clean-all: clean-sqlite clean-mongo

# Create admin user in hs1
.PHONY: create-user-hs1
create-user-hs1:
	docker exec -it hs1 register_new_matrix_user -u admin -p admin --admin http://localhost:8008 -c /data/homeserver.yaml

# Create admin user in hs2
.PHONY: create-user-hs2
create-user-hs2:
	docker exec -it hs2 register_new_matrix_user -u admin -p admin --admin http://localhost:8008 -c /data/homeserver.yaml

# Create admin users in hs1 and hs2
.PHONY: create-users-hs
create-users-hs: create-user-hs1 create-user-hs2

.PHONY: setup
setup:
	@printf "\033[1;36m\nRunning: make install-root-ca\033[0m\n\n"
	@$(MAKE) install-root-ca | sed 's/^/  /'
	@printf "\033[1;36m\nRunning: make apply-hosts\033[0m\n\n"
	@$(MAKE) apply-hosts | sed 's/^/  /'
