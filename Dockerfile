## Start with the tidyverse docker image
FROM seabbs/tidyverse-gpu

MAINTAINER "Sam Abbott" sam.abbott@bristol.ac.uk

ADD . /home/rstudio/benchmark-libbi

WORKDIR /home/rstudio/benchmark-libbi

## Get thrust - not needed when we have cuda but included for completeness
RUN wget https://github.com/thrust/thrust/releases/download/1.8.2/thrust-1.8.2.zip \
    && unzip thrust-1.8.2.zip\
    && mv thrust /usr/local/include

## Set env for Libbi
ENV PERL_MM_USE_DEFAULT=1

## Get LibBi (and deps)
RUN git clone https://github.com/lawmurray/LibBi.git \
  && cd LibBi \
  && sudo apt-get install -y \
    libblas-dev \
    liblapack-dev \
    libqrupdate-dev \
    libboost-all-dev \
    libgsl0-dev \
    libnetcdf-dev \
    autoconf \
    automake \
  && sudo cpan .

### Get R package libraries
RUN apt-get install -y \
     libnetcdf-dev \
     && apt-get clean


### Get R packages for interfacing with LiBbi
RUN Rscript -e 'devtools::install_github("sbfnk/rbi"); devtools::install_github("sbfnk/rbi.helpers")'

WORKDIR /home/rstudio/benchmark-libbi
