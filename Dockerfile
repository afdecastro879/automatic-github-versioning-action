FROM gittools/gitversion:5.6.1-linux-ubuntu-18.04-netcoreapp3.1
ENV PATH="/tools:${PATH}"
RUN apt-get update && apt-get install -y git curl

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]