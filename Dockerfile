# Stage 1 Download and expand
FROM alpine:3.13.6 as builder
WORKDIR /build
COPY scripts scripts
RUN wget https://github.com/syncthing/syncthing/releases/download/v1.18.2/syncthing-linux-amd64-v1.18.2.tar.gz && \
    tar xzf syncthing-linux-amd64-v1.18.2.tar.gz
RUN mkdir /app && \
    cp -R syncthing-linux-amd64-v1.18.2/* /app

# # Stage 2 Clean image to run
FROM alpine:3.13.6

# ## SET USER and GROUP from env
ENV PUID=1000
ENV PGID=1000

# # Set overall app dir permissions to allow auto-upgrades at runtime
RUN mkdir /app && \
    chown $PUID:$PGID /app
WORKDIR /app

# # Copy app from builder image, using PUID and PGID
COPY --chown=$PUID:$PGID --from=builder /app .
COPY --from=builder /build/scripts scripts

# # Required dependencies
RUN apk add --no-cache ca-certificates su-exec tzdata

# # Set environment for homedir, mapped to exposed volume
ENV HOME=/home/sync_user

# # SET GUI ADDRESS
ENV STGUIADDRESS=0.0.0.0:8384

# # Required ports for SyncThing
EXPOSE 21027/udp
EXPOSE 22000/tcp
EXPOSE 22000/udp
EXPOSE 8384/tcp

# # Create homedir, and expose file volume
RUN mkdir /home/sync_user
VOLUME /home/sync_user

# # Run the service
ENTRYPOINT ["./scripts/docker-entrypoint.sh", "./syncthing"]