FROM ubuntu:18.04
RUN apt update && apt install -y curl
ADD ./bin/n /usr/bin
#ENTRYPOINT ["/usr/bin/n"]
CMD ["n", "latest"]

