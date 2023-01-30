# Set the base image to Ubuntu
FROM ubuntu:20.04

# Add timezone so that tzdata does not hang to ask for timezone
# https://grigorkh.medium.com/fix-tzdata-hangs-docker-image-build-cdb52cc3360d
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install utilities and Python
RUN apt-get update && DEBIAN_FRONTEND=noninteractive && \
	apt-get install --yes --no-install-recommends \
    # Install utilities
	tzdata apt-utils curl wget bzip2 nano gnupg apt-transport-https git  \
    # Install Python and pip
    python3-dev python3-pip python3-pycurl \
    # Install dependencies
    build-essential libssl-dev libffi-dev libbz2-dev liblzma-dev libncurses5-dev \
    software-properties-common

# install miniconda

ENV PATH="~/.conda/bin:$PATH"
ARG PATH="~/.conda/bin:$PATH"

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir ~/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -bup ~/.conda \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

RUN ~/.conda/bin/conda --version

RUN ~/.conda/bin/conda install -c bioconda -y vcftools


# Install Pharmcat
# based on https://github.com/PharmGKB/PharmCAT/blob/development/Dockerfile

# install java
RUN wget https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public
RUN gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --import public
RUN gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --export --output adoptopenjdk-archive-keyring.gpg
RUN rm adoptopenjdk-keyring.gpg
RUN mv adoptopenjdk-archive-keyring.gpg /usr/share/keyrings && \
    chown root:root /usr/share/keyrings/adoptopenjdk-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/adoptopenjdk-archive-keyring.gpg] https://adoptopenjdk.jfrog.io/adoptopenjdk/deb bullseye main" \
    | tee /etc/apt/sources.list.d/adoptopenjdk.list
RUN apt-get update && \
    apt-get -y install --no-install-recommends adoptopenjdk-16-hotspot && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get clean

RUN mkdir /pharmcat
WORKDIR /pharmcat
# download fasta files
RUN wget https://zenodo.org/record/5572839/files/GRCh38_reference_fasta.tar
RUN tar -xf GRCh38_reference_fasta.tar

ENV BCFTOOLS_VERSION 1.14
ENV HTSLIB_VERSION 1.14
ENV SAMTOOLS_VERSION 1.14

# download the suite of tools
WORKDIR /usr/local/bin/
RUN wget https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2
RUN wget https://github.com/samtools/bcftools/releases/download/${BCFTOOLS_VERSION}/bcftools-${BCFTOOLS_VERSION}.tar.bz2
RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2

# extract files for the suite of tools
RUN tar -xjf /usr/local/bin/htslib-${HTSLIB_VERSION}.tar.bz2 -C /usr/local/bin/
RUN tar -xjf /usr/local/bin/bcftools-${BCFTOOLS_VERSION}.tar.bz2 -C /usr/local/bin/
RUN tar -xjf /usr/local/bin/samtools-${SAMTOOLS_VERSION}.tar.bz2 -C /usr/local/bin/

# compile tools
RUN cd /usr/local/bin/htslib-${HTSLIB_VERSION}/ && ./configure
RUN cd /usr/local/bin/htslib-${HTSLIB_VERSION}/ && make && make install
RUN cd /usr/local/bin/bcftools-${BCFTOOLS_VERSION}/ && ./configure
RUN cd /usr/local/bin/bcftools-${BCFTOOLS_VERSION}/ && make && make install
RUN cd /usr/local/bin/samtools-${SAMTOOLS_VERSION}/ && ./configure
RUN cd /usr/local/bin/samtools-${SAMTOOLS_VERSION}/ && make && make install

# cleanup
RUN rm  -f /usr/local/bin/bcftools-${BCFTOOLS_VERSION}.tar.bz2
RUN rm -rf /usr/local/bin/bcftools-${BCFTOOLS_VERSION}
RUN rm  -f /usr/local/bin/htslib-${HTSLIB_VERSION}.tar.bz2
RUN rm -rf /usr/local/bin/htslib-${HTSLIB_VERSION}
RUN rm  -f /usr/local/bin/samtools-${SAMTOOLS_VERSION}.tar.bz2
RUN rm -rf /usr/local/bin/samtools-${SAMTOOLS_VERSION}

WORKDIR /pharmcat
# setup python env
COPY scripts/preprocessor/PharmCAT_VCF_Preprocess_py3_requirements.txt ./
RUN pip3 install -r PharmCAT_VCF_Preprocess_py3_requirements.txt

# add pharmcat scripts
COPY scripts/preprocessor/*.py ./
COPY scripts/pharmcat ./
RUN chmod 755 *.py
RUN chmod 755 pharmcat
COPY pharmcat_positions/* ./
COPY jar/pharmcat.jar ./

# Install whatshap

# Export path for whatshap
ENV PATH=$HOME/.local/bin:$PATH

# Install whatshap
RUN pip install whatshap

# Create folder for code
#RUN mkdir /home/python
#WORKDIR /home/python

# Run python shell
# CMD ["python3"]

# Keep alive container
# ENTRYPOINT ["tail", "-f", "/dev/null"]




