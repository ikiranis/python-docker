# Set the base image to Ubuntu
FROM ubuntu:20.04

# Add timezone so that tzdata does not hang to ask for timezone
# https://grigorkh.medium.com/fix-tzdata-hangs-docker-image-build-cdb52cc3360d
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install utilities and Python
RUN apt-get update && DEBIAN_FRONTEND=noninteractive && \
	apt-get install --yes --no-install-recommends \
	tzdata \
	apt-utils \
	curl \
	wget \
    nano \
	apt-transport-https \
    python3-dev python3-pip \
    build-essential libssl-dev libffi-dev libbz2-dev liblzma-dev \
    software-properties-common && \
	rm -rf /var/lib/apt/lists/*

RUN apt-get clean

# Export path for whatshap
ENV PATH=$HOME/.local/bin:$PATH

# Install whatshap
RUN pip install whatshap

# Create folder for code
RUN mkdir /home/python
WORKDIR /home/python

# Run python shell
# CMD ["python3"]

# Keep alive container
ENTRYPOINT ["tail", "-f", "/dev/null"]




