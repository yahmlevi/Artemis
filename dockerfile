FROM python:3.9

# COPY . /requirements_temp

WORKDIR /Artemis

RUN apt-get update \
  && apt-get install nodejs -y \
  && apt-get install npm -y \
  && npm install -g ganache-cli

RUN pip install -r /requirements_temp/requirements.txt \
  && python -m pip install --user pipx \
  && python -m pipx ensurepath --force

# TODO !!
# 1. manually install the following - 'pipx install eth-brownie'

# docker run -it --rm -v "/${PWD}:/freeCodeCamp" web3-all-in-one bash

# docker run -it --rm -v "/${PWD}:/Artemis" python:3.9 bash