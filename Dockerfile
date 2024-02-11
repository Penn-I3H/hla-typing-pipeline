FROM rocker/r-ver:4.3.2

WORKDIR /service

RUN apt clean && apt-get update && apt-get -y install alien

# R program dependencies
RUN apt-get install -y libudunits2-dev && apt-get install -y libgeos-dev && apt-get install -y libproj-dev && apt-get -y install libnlopt-dev && apt-get -y install pkg-config && apt-get -y install gdal-bin && apt-get install -y libgdal-dev
RUN apt-get -y install libcurl4-openssl-dev libfontconfig1-dev libxml2-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev

RUN R --version

COPY dependencies ./dependencies

## Add additional program specific dependencies below ...
# install autoHLA package
# RUN Rscript -e "install.packages(c('RColorBrewer', 'viridis', 'ggsci', 'magrittr', 'mblm', 'rstatix', 'psych', 'uwot', 'reshape2', 'plotly', 'spdep', 'KernSmooth'), Ncpus = 10)"
RUN Rscript -e "install.packages(c('BH'), Ncpus = 10, repos = 'https://cloud.r-project.org/', dependencies = TRUE)"
RUN Rscript -e "install.packages(c('tidyverse'), Ncpus = 10, dependencies=TRUE)"
RUN Rscript -e "library(tidyverse)"
RUN Rscript -e "install.packages(c('KernSmooth', 'ggridges'), Ncpus = 10, dependencies=TRUE)"

RUN Rscript -e "install.packages(c('BiocManager'), Ncpus=10)"
RUN Rscript -e "BiocManager::install('RProtoBufLib')"
RUN Rscript -e "BiocManager::install('cytolib', version='3.18')"
RUN Rscript -e "library(cytolib)"
RUN Rscript -e "BiocManager::install('flowCore')"

RUN Rscript -e "install.packages('./dependencies/autoHLA', repos=NULL, type='source')"

# entrypoint
COPY . ./

RUN ls /service

RUN mkdir -p data

ENTRYPOINT [ "Rscript", "/service/main.R" ]
