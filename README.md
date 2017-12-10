Plex Media Player - Build and Run in Docker. Checkinstall in Docker.
====================================================================

Depends: make, docker.io, and Plexinc fixing their conan server.

        sudo apt-get install make docker.io

I did some Dockerfile/Makefile abuse, which [will be useful once Plex gets their Conan server running again](https://github.com/plexinc/plex-media-player/issues/641).
It's really simple, just a Dockerfile and a Makefile which should set up a very
predictable build environment, build PMP from source, package it with
Checkinstall(Which will create a .deb file if you want it) and optionally,
run it from within the container. The commands are

        make info: Shows details about the package to be built.
        make build: Builds the docker container and the PMP package within it.
        make run: Runs PMP in the docker container, forwarding the necessary resources from the host.
        make open: Starts the docker container without running PMP to allow you to extract the .deb if you want.
        make deb: Automatically makes sure the .deb is built and extracts it to the working directory.
        make clean: Automatically deletes the docker containers and build artifacts.
