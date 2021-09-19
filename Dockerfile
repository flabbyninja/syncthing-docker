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
WORKDIR /app

# # Copy app from builder image
COPY --from=builder /app .
COPY --from=builder /build/scripts scripts

# # Required dependencies
RUN apk add --no-cache ca-certificates su-exec tzdata

# ## SET USER and GROUP
# # ARG USER=sync_user
# # ARG GROUP=sync_users
ENV PUID=1000
ENV PGID=1000
RUN mkdir /home/sync_user

# # SET GUI ADDRESS
ENV STGUIADDRESS=0.0.0.0:8384

# # Required ports fopr SyncThing
EXPOSE 21027/udp
EXPOSE 22000/tcp
EXPOSE 22000/udp
EXPOSE 8384/tcp

# # Expose file volumes
VOLUME /home/sync_user

# # Run the service
ENTRYPOINT ["./scripts/docker-entrypoint.sh", "./syncthing", "-home", "/home/sync_user"]