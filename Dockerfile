############################################################
# Dockerfile for genome_to_report.nf
# Based on ubuntu
############################################################

# Set the base image to Ubuntu
FROM ubuntu:20.04

# Add timezone so that tzdata does not hang to ask for timezone
# https://grigorkh.medium.com/fix-tzdata-hangs-docker-image-build-cdb52cc3360d
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set up miniconda path
#ENV PATH="/root/miniconda3/bin:${PATH}"
#ARG PATH="/root/miniconda3/bin:${PATH}"

# Install utilities and Python
RUN apt-get update && DEBIAN_FRONTEND=noninteractive && \
	apt-get install --yes --no-install-recommends \
	tzdata \
	apt-utils \
	curl \
	wget \
    nano \
    build-essential libssl-dev libffi-dev python3-dev \
    python3-pip \
	apt-transport-https \
    software-properties-common && \
	rm -rf /var/lib/apt/lists/*

RUN apt-get clean

# Fix certificate issues
#RUN apt-get update && \
#    apt-get install ca-certificates-java && \
#    apt-get clean && \
#    update-ca-certificates -f;


