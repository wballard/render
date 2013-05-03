
DIFF?=git --no-pager diff --ignore-all-space --color-words --no-index
RENDER ?=./bin/render

.PHONY: test

test:
	$(MAKE) test_handlebars test_handlebars_with_helpers

test_handlebars:
	export GOOFY=GOOFY!; \
	cat test/sample.yaml \
	| $(RENDER) test/sample.handlebars \
	| tee /tmp/$@
	$(DIFF) /tmp/$@ test/expected/$@

test_handlebars_with_helpers:
	cat test/sample.yaml | $(RENDER) --require ./test/handlebarhelpers.coffee test/withhelpers.handlebars \
	| tee /tmp/$@
	$(DIFF) /tmp/$@ test/expected/$@

test_pass:
	DIFF=cp $(MAKE) test
