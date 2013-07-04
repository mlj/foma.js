all: foma.js test.js

foma.js: foma.coffee
	coffee -c foma.coffee

test.js: test.bin
	./foma2js $< > $@
