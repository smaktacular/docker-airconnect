FROM ubuntu

COPY supervisord.conf /etc

WORKDIR /bin
RUN apt update && apt install -y supervisor wget unzip curl \ 
  && curl -s https://api.github.com/repos/philippe44/AirConnect/releases/latest 2>&1 \
  | grep "browser_download_url.*" \
  | cut -d '"' -f 4 > url \
  && echo "url contents:" && cat url \
  && xargs -n 1 curl -L -o ac.zip < url \
  && unzip ac.zip airupnp-x86-64 aircast-x86-64 \
  && chmod +x /bin/airupnp-x86-64 /bin/aircast-x86-64 \
  && rm -rf ac.zip url 

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
