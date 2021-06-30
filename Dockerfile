FROM gittools/gitversion:5.6.1-ubuntu.20.04-x64-3.1
ENV PATH="/tools:${PATH}"
RUN apt-get update && apt-get install -y git curl jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
