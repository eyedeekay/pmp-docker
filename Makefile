
VERSION = $(shell wget -qO - https://api.github.com/repos/plexinc/plex-media-player/releases/latest | grep tag_name | sed 's|"tag_name": ||' | tr -d ' ,\"')

info:
	@echo $(VERSION)

build:
	docker build -f Dockerfile -t plex-media-player .

run:
	docker run -ti --rm \
		-e DISPLAY=${DISPLAY} \
		--device /dev/snd \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=unix$DISPLAY \
		plex-media-player

open:
	docker run -t -d --rm plex-media-player-box bash

deb: build open
	docker cp plex-media-player:/home/plexmediaplayer/pms/plex-media-player_$(VERSION).deb .
	docker rm -f plex-media-player-box; docker rmi -f plex-media-player-box; true

clean:
	docker rm -f plex-media-player; \
	docker rmi -f plex-media-player; \
	rm -f *.deb
