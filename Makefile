PREFIX?=/usr/local

PROD_NAME=ObjcImportSorter
PROD_NAME_UNDERLINE=objc-import-sorter

build:
	swift build --disable-sandbox -c release -Xswiftc -static-stdlib

run:
	.build/release/$(PROD_NAME)

clean:
	swift package clean

test: xcode
    set -o pipefail && xcodebuild -scheme ObjcImportSorter-Package -enableCodeCoverage YES clean build test | xcpretty

xcode:
	swift package generate-xcodeproj

install: build
	mkdir -p "$(PREFIX)/bin"
	cp -f ".build/release/$(PROD_NAME)" "$(PREFIX)/bin/$(PROD_NAME_UNDERLINE)"

