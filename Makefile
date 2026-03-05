PREFIX := /usr/local
VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
REPO := syarihu/calday
TAP_FORMULA := ../homebrew-tap/Formula/calday.rb

.PHONY: build install release

build:
	swift build -c release

install: build
	cp .build/release/calday $(PREFIX)/bin/

release:
	@read -p "New version (current: $(VERSION)): " version; \
	git tag $$version && \
	git push origin $$version && \
	gh release create $$version --title "$$version" --generate-notes && \
	url="https://github.com/$(REPO)/archive/refs/tags/$$version.tar.gz" && \
	sha=$$(curl -sL $$url | shasum -a 256 | cut -d' ' -f1) && \
	sed -i '' 's|url ".*"|url "'$$url'"|' $(TAP_FORMULA) && \
	sed -i '' 's|sha256 ".*"|sha256 "'$$sha'"|' $(TAP_FORMULA) && \
	cd $$(dirname $(TAP_FORMULA))/.. && \
	git add -A && \
	git commit -m "Update calday to $$version" && \
	git push origin main && \
	echo "Done! $$version released"
