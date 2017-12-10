
VERSION = $(shell wget -qO - https://api.github.com/repos/plexinc/plex-media-player/releases/latest | grep tag_name | sed 's|"tag_name": ||' | tr -d ' ,\"')
include /etc/os-release

DISTRO ?= $(ID)

info:
	@echo "Plex Media Player Unofficial Builder"
	@echo "===================================="
	@echo ""
	@echo "Building version: $(VERSION) $(DISTRO)"
	@echo ""
	@echo "make info: Shows details about the package to be built."
	@echo "make build: Builds the docker container and the PMP package within it."
	@echo "make run: Runs PMP in the docker container, forwarding the necessary resources from the host."
	@echo "make open: Starts the docker container without running PMP to allow you to extract the .deb if you want."
	@echo "make deb: Automatically makes sure the .deb is built and extracts it to the working directory."
	@echo "make clean: Automatically deletes the docker containers and build artifacts."

build:
	docker build -f Dockerfile.$(DISTRO) -t plex-media-player-$(DISTRO) .

run: build
	docker run -ti --rm \
		-e DISPLAY=$(DISPLAY) \
		--device /dev/snd \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=unix$(DISPLAY) \
		plex-media-player-$(DISTRO)

open: build
	docker run -t -d --rm --name plex-media-player-box plex-media-player-$(DISTRO) bash

deb: open
	docker cp plex-media-player-box:/home/plexmediaplayer/pms/plex-media-player_$(VERSION).deb .
	docker rm -f plex-media-player-box; docker rmi -f plex-media-player-box; true

clean:
	docker rm -f plex-media-player-$(DISTRO); \
	docker rmi -f plex-media-player-$(DISTRO); \
	docker system prune -f; \
	rm -f *.deb
