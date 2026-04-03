APP=src
COLLECTION=-collection:app=$(APP)
BIN=ovm

build:
	odin build $(APP) $(COLLECTION) -vet -out:$(BIN)

run: build
	./$(BIN)

ls: build
	./$(BIN) ls

install: build
	./$(BIN) install $(VERSION)

clean:
	rm -f $(BIN)
