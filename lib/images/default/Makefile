<%# vim: set ft=eruby: -%>
<%- skip unless options.comprehensive -%>
TARGET  := <%= meta.output %>
SOURCES := template.json template.preseed template.vagrantfile template.sh

# Make all
all: validate build test publish
.PHONY: all

# Validate template
validate: .validate
.PHONY: validate

# Build image
build: .build
.PHONY: build

# Test image
test: .test
.PHONY: test

# Publish image
publish: .publish
.PHONY: publish

# Clean
clean:
	@rm -rf .validate .build .test .publish
.PHONY: clean

# Purge
purge: clean
	@rm -f $(TARGET)
.PHONY: purge

.validate: template.json
	@img validate
	@touch $@

.build: $(TARGET) .validate
	@echo img build
	@touch $@

.test: .build
	@echo img test
	@touch $@

.publish: .test
	@echo img publish
	@touch $@

$(TARGET): $(SOURCES)
	@touch $@
