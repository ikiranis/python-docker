#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
# https://stackoverflow.com/questions/31196567/installing-java-in-docker-image
# https://github.com/chrishah/samtools-docker/blob/master/Dockerfile # needed to modify samtools installation following next link below
# https://gist.github.com/mictadlo/71d404441f3fc628bf851650c07f4a90 # samtools installed in root so 
#

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
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

# Install compiler and dependencies for samtools and R
RUN apt-get update && DEBIAN_FRONTEND=noninteractive && \
	apt-get install --yes --no-install-recommends \
	tzdata \
	apt-utils \
	curl \
	wget \
	openjdk-8-jdk \
	# required elements for samtools installation
	autoconf \ 
	automake \ 
	make \
	gcc \
	perl \
	zlib1g-dev \ 
	libbz2-dev \
	liblzma-dev \
	# libcurl4-gnutls-dev conflicts with libcurl4-openssl-dev 
	libssl-dev \ 
	libperl-dev \
	libgsl0-dev \
	libncurses5-dev \
	# needed for R package 'RcppEigen'
	gfortran \  
	libblas-dev \
	liblapack-dev \
	libxml2-dev \
	# needed for R package 'curl'
	libcurl4-openssl-dev \
	# needed for R package 'RMySQL'
	libmariadbclient-dev \
	# needed for R package 'RPostgreSQL'
	libpq-dev \
	# needed for R package 'png'
	libpng-dev \
	# needed for R package 'jpeg'
	libjpeg-dev \
	# needed for R package 'systemfonts'
	libfontconfig1-dev \
	# needed for latex / markdown
	texlive \
	texlive-xetex \
	texlive-extra-utils \
	texlive-latex-base \
	texlive-latex-recommended \
	texlive-fonts-recommended \
	texlive-plain-generic \
	lmodern \
	pandoc \
	libmagick++-dev \
	imagemagick \
	#required element for R installation
	dirmngr \
	gnupg \
	apt-transport-https \
	ca-certificates \ 
	software-properties-common && \
	rm -rf /var/lib/apt/lists/*
	
RUN apt-get clean

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# install miniconda
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 
RUN conda --version

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Install samtools and vcftools
RUN conda install -c bioconda -y samtools=1.11
RUN conda install -c bioconda -y vcftools

#install R
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/' && \
    apt install --yes --no-install-recommends r-base  \ 
	#to install packages
	build-essential && \
	apt-get update --fix-missing 

# Install R libraries
RUN R -e "install.packages('stringi',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tidyverse',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# eeptools dependencies
RUN R -e "install.packages('curl',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('RMySQL',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('RPostgreSQL',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('RcppEigen',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('png',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('jpeg',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('lme4',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('lmtest',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('vcd',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('latticeExtra',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('Hmisc',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('arm',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# install eeptools
RUN R -e "install.packages('eeptools',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# install kableExtra
RUN R -e "install.packages('kableExtra',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# install bookdown
RUN R -e "install.packages('bookdown',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# install varhandle
RUN R -e "install.packages('varhandle',dependencies=TRUE, repos='http://cran.rstudio.com/')"

## change executable directory and update path for miniconda to work on azure
# RUN mv /root/miniconda3/ /usr/bin/
# ENV PATH="/usr/bin/miniconda3/bin:$PATH"

# copy logo and font files to docker image
COPY files_for_docker /usr/local/share/

#RUN chmod -R 777 /root/miniconda3
#RUN chmod -R 777 /usr/local/share/
