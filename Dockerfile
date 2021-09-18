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
COPY --from=builder /app .
CMD sh









