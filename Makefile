.DEFAULT_GOAL := help

help:
	@echo "Available commands:"
	@echo "  make clean-sqlite    - Remove SQLite data files (hs1 and hs2)"
	@echo "  make clean-mongo     - Remove MongoDB data"
	@echo "  make clean-all       - Run all cleanup commands"
	@echo "  make create-user-hs1 - Create admin user in hs1"
	@echo "  make create-user-hs2 - Create admin user in hs2"
	@echo "  make create-users-hs - Create admin users in hs1 and hs2"

.PHONY: clean-sqlite clean-mongo clean-all create-user-hs1 create-user-hs2 create-users-hs

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
