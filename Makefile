PROJECT   ?= <TODO>
BUILD_TAG ?= build-local

IMAGE_TAG = $(PROJECT):$(BUILD_TAG)

export IMAGE_TAG

all:
	@echo "Available targets:"
	@echo "  * build   - Build a Docker image for $(PROJECT)"
	@echo "  * dev     - Run dev console for $(PROJECT)"
	@echo "  * test    - Run tests for $(PROJECT)"

revision:
	$(eval GIT_COMMIT = $(shell git rev-parse HEAD))

build: revision
	docker build -t $(IMAGE_TAG) --label "git_commit=$(GIT_COMMIT)" -f Dockerfile .

dev: dev-up
	docker-compose -f docker-compose.dev.yml exec slack-bot ash

dev-up:
	docker-compose -f docker-compose.dev.yml up --build --remove-orphans -d

dev-down:
	docker-compose -f docker-compose.dev.yml down --remove-orphans -v

test: test-up test-run test-down

test-up:
	docker-compose -f docker-compose.ci.yml up --build --remove-orphans -d

test-run:
	docker-compose -f docker-compose.ci.yml run --rm slack-bot bundle exec rspec

test-down:
	docker-compose -f docker-compose.ci.yml down --remove-orphans -v
