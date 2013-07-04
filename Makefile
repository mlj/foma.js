all: foma.js test.json

foma.js: foma.coffee
	coffee -c foma.coffee

test.json: foma2js
	./foma2js test.bin > $@
