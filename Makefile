IMAGE = snice-testing
REGISTRY = registry.snice.io
VERSION=$(shell awk '/<io.snice.testing.version>/{print $1}' pom.xml | cut -d '>' -f 2 | cut -d '<' -f 1)
TAG = $(REGISTRY)/$(IMAGE):${VERSION}

# See https://maven.apache.org/plugins/maven-dependency-plugin/copy-dependencies-mojo.html
# for all options
deps:
	rm -rf lib
	mvn -DoutputDirectory=lib -Dmdep.prependGroupId=true -DincludeScope=runtime org.apache.maven.plugins:maven-dependency-plugin:3.5.0:copy-dependencies

build: deps
	docker build -t ${TAG} .

login:
	docker login ${REGISTRY}

push:
	docker push ${TAG}
