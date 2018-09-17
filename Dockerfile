FROM openjdk:8

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		curl wget apt-transport-https libsnappy-dev libssl-dev libbz2-dev python-dev python-pip zip unzip python-setuptools\
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get clean
RUN pip install --upgrade awscli

# https://github.com/docker-library/openjdk/issues/145#issuecomment-334561903
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=894979
RUN rm /etc/ssl/certs/java/cacerts ; update-ca-certificates -f
RUN mkdir -p /opt/secor
ADD target/secor-*-bin.tar.gz /opt/secor/
RUN ln -s /opt/secor/secor-0.27-SNAPSHOT.jar /opt/secor/secor.jar

COPY src/main/scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
