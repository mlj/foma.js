all: foma.js test.json test.js

%.js: %.coffee
	coffee -c $<

test.json: test.bin foma2json
	./foma2json test.bin | prettify_json.rb > $@
