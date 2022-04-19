FROM python:3.9

WORKDIR /Artemis

RUN apt-get update \
  && apt-get install nodejs -y \
  && apt-get install npm -y \
  && npm install -g ganache-cli

RUN python -m pip install --user pipx \
  && python -m pipx ensurepath --force \
  && python3 -m pipx install eth-brownie


# docker build -t brownie-workspace .
# docker run -it --rm -v "/${PWD}:/Artemis" brownie-workspace bash