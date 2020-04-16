FROM gittools/gitversion:5.2.4-linux-ubuntu-18.04-netcoreapp3.1
ENV PATH="/tools:${PATH}"
RUN apt-get update && apt-get install -y git curl

ENTRYPOINT ["./entrypoint.sh"]