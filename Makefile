NODE = node
MOCHA = ./node_modules/.bin/mocha

REPORTER = dot
MOCHA_OPTS = --colors --growl --check-leaks

test: test-unit

test-unit:
	@./node_modules/.bin/mocha \
		--compilers coffee:coffee-script/register \
		--reporter $(REPORTER) \
		$(MOCHA_OPTS)

.PHONY: test test-unit

