# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ENV PATH="/root/.TinyTeX/bin/aarch64-linux:${PATH}"
COPY install_scripts/install_apt.sh /install_scripts/
RUN /install_scripts/install_apt.sh
COPY install_scripts/install_R.sh /install_scripts/
RUN /install_scripts/install_R.sh
COPY install_scripts/install_tex.sh /install_scripts/
RUN /install_scripts/install_tex.sh
COPY install_scripts/install_utils.sh /install_scripts/
RUN /install_scripts/install_utils.sh
COPY tests /tests
RUN /tests/test_R.sh
