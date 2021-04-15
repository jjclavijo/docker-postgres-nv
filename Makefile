#HTTP_PROXY:=http://proxylh.fi.uba.ar:8080
#HTTPS_PROXY:=http://proxylh.fi.uba.ar:8080
BUILD_TAG:=postgres-nv:12

.PHONY: default
defualt: build

Dockerfile:
ifndef HTTPS_PROXY
	curl -L https://github.com/docker-library/postgres/raw/master/12/Dockerfile -O -J
else
	curl -x $(HTTPS_PROXY) -L https://github.com/docker-library/postgres/raw/master/12/Dockerfile -O -J
endif
	sed -i 's/^VOLUME/\#VOLUME/' $@
ifdef HTTP_PROXY
	sed -Ei 's/gpg (.*) --keyserver /gpg \1 --keyserver-options http-proxy="$(subst /,\/,$(HTTP_PROXY))" --keyserver /g' $@
endif
	sed -i 's/^FROM debian/FROM docker.io\/debian/' $@
	sed -i '/COPY docker-entrypoint.*/a RUN chmod +x /usr/local/bin/docker-entrypoint.sh' $@


docker-entrypoint.sh:
ifndef HTTPS_PROXY
	curl -L https://github.com/docker-library/postgres/raw/master/12/docker-entrypoint.sh -O -J
else
	curl -x $(HTTPS_PROXY) -L https://github.com/docker-library/postgres/raw/master/12/docker-entrypoint.sh -O -J
endif

.PHONY: build
build: Dockerfile docker-entrypoint.sh
	docker build . -t $(BUILD_TAG)
