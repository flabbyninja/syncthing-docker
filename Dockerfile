# Stage 1 Download and expand
FROM alpine:3.13.6 as builder
WORKDIR /tmp
RUN wget https://github.com/syncthing/syncthing/releases/download/v1.18.2/syncthing-linux-amd64-v1.18.2.tar.gz && \
    tar xzf syncthing-linux-amd64-v1.18.2.tar.gz
RUN mkdir /app && \
    cp -R syncthing-linux-amd64-v1.18.2/* /app

# Stage 2 Clean image to run
FROM alpine:3.13.6
WORKDIR /app

# Copy app from builder image
COPY --from=builder /app .

## SET USER and GROUP
ARG USER=sync_user
ARG GROUP=sync_users
ARG UID=1000
ARG GID=1000
RUN addgroup -g ${GID} ${GROUP}
RUN adduser -u ${UID} -G ${GROUP} -D ${USER}

EXPOSE 8384

# Switch to user
USER ${UID}:${GID}
CMD ./syncthing









