.DEFAULT_GOAL := help

help:
	@echo "Available commands:"
	@echo "  make clean-sqlite    - Remove SQLite data files (hs1 and hs2)"
	@echo "  make clean-mongo     - Remove MongoDB data"
	@echo "  make clean-all       - Run all cleanup commands"
	@echo "  make create-user-hs1 - Create admin user in hs1"
	@echo "  make create-user-hs2 - Create admin user in hs2"
	@echo "  make create-users-hs - Create admin users in hs1 and hs2"
	@echo "  make apply-hosts     - Add missing entries from project hosts file to /etc/hosts (shows green for added, gray for existing, yellow alert if sudo required)"

.PHONY: apply-hosts clean-sqlite clean-mongo clean-all create-user-hs1 create-user-hs2 create-users-hs

# Apply entries from the hosts file to the machine's /etc/hosts
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
clean-sqlite:
	rm -rf hs1/*.db hs1/*.db-* hs1/media_store
	rm -rf hs2/*.db hs2/*.db-* hs2/media_store

# Remove MongoDB data
clean-mongo:
	rm -rf mongodb/data

# Run all cleanup commands
clean-all: clean-sqlite clean-mongo

# Create admin user in hs1
create-user-hs1:
	docker exec -it hs1 register_new_matrix_user -u admin -p admin --admin http://localhost:8008 -c /data/homeserver.yaml

# Create admin user in hs2
create-user-hs2:
	docker exec -it hs2 register_new_matrix_user -u admin -p admin --admin http://localhost:8008 -c /data/homeserver.yaml

# Create admin users in hs1 and hs2
create-users-hs: create-user-hs1 create-user-hs2
