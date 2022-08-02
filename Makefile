postgres:
	docker run --name postgres14 -p 5432:5432  -e POSTGRES_USER=root -e POSTGRES_PASSWORD=anhhung -d postgres:14-alpine
createdb:
	docker exec -it postgres14 createdb --username=root --owner=root simple_bank
dropdb:
	docker exec -it postgres14 dropdb simple_bank
migrateup:
	migrate -path db/migration -database "postgresql://root:anhhung@localhost:5432/simple_bank?sslmode=disable" -verbose up
migratedown:
	migrate -path db/migration -database "postgresql://root:anhhung@localhost:5432/simple_bank?sslmode=disable" -verbose down
migrateup1:
	migrate -path db/migration -database "postgresql://root:anhhung@localhost:5432/simple_bank?sslmode=disable" -verbose up 1
migratedown1:
	migrate -path db/migration -database "postgresql://root:anhhung@localhost:5432/simple_bank?sslmode=disable" -verbose down 1
sqlc:
	sqlc generate
test:
	go test -v -cover ./...
server:
	go run main.go
mock:
	mockgen -build_flags=--mod=mod -package mockdb -destination db/mock/store.go simplebank/db/sqlc Store
.PHONY: createdb dropdb postgres sqlc server mock test migratedown1 migrateup1