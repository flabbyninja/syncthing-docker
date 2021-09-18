# SyncThing Docker

Minimal SyncThing image based on `alpine` and running as restricted user.

Exposes volume to allow configuration, and for sync'd directories to be persisted outside container.

docker-compose file included to spin up workload.

Build the image with:

`docker build -t syncthing-min .`