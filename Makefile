ARTICLE ?=
ARTICLE_LANGS ?=

.DEFAULT_GOAL := help

.PHONY: help stage draft preview build deploy

publish_args = "$(ARTICLE)" $(ARTICLE_LANGS)

help:
	@echo "Engineering Decisions site workflow"
	@echo ""
	@echo "Usage:"
	@echo "  make draft ARTICLE=<article-slug> [ARTICLE_LANGS='en pt-br']"
	@echo "  make stage ARTICLE=<article-slug> [ARTICLE_LANGS='en pt-br']"
	@echo "  make preview"
	@echo "  make build"
	@echo "  make deploy"
	@echo ""
	@echo "Commands:"
	@echo "  draft   Copy article translations into site repo as draft:true"
	@echo "  stage   Copy article translations into site repo as draft:false"
	@echo "  preview Run Hugo local server with drafts enabled"
	@echo "  build   Run production-style Hugo build"
	@echo "  deploy  Build site and then run deploy flow placeholder"

draft:
	@if [ -z "$(ARTICLE)" ]; then echo "Usage: make draft ARTICLE=001-ai-made-code-cheap [ARTICLE_LANGS='en pt-br']"; exit 1; fi
	PUBLISH_MODE=draft sh scripts/publish_from_editorial.sh $(publish_args)

stage:
	@if [ -z "$(ARTICLE)" ]; then echo "Usage: make stage ARTICLE=001-ai-made-code-cheap [ARTICLE_LANGS='en pt-br']"; exit 1; fi
	PUBLISH_MODE=final sh scripts/publish_from_editorial.sh $(publish_args)

preview:
	hugo server -D --disableFastRender

build:
	hugo

deploy: build
	@echo "Deploy not configured yet."
	@echo "Current flow:"
	@echo "  1. make stage ARTICLE=<article-slug>"
	@echo "  2. git add . && git commit -m 'Stage <article>' && git push"
	@echo "  3. run hosting deploy pipeline or upload ./public"
	@echo "Future: wire this target to shared hosting or CI deployment."
