FROM ubuntu

# Add Supervisor
RUN apt update && apt install -y supervisor wget unzip
COPY supervisord.conf /etc

WORKDIR /bin
# Download AirConnect
RUN curl -s https://api.github.com/repos/philippe44/AirConnect/releases/latest 2>&1 \
 | grep "browser_download_url.*" \
 | cut -d '"' -f 4 \
 | xargs curl -LJo ac.zip 
ADD ${URL} /bin/
RUN unzip ac.zip airupnp-x86-64 aircast-x86-64 \
 && chmod +x /bin/airupnp-x86-64 /bin/aircast-x86-64

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
