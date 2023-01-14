FROM debian:unstable-slim

ENV DEBIAN="noninteractive"
ENV XDG_CONFIG_DIR="~/.config"
ENTRYPOINT ["nvim"]
CMD []

RUN apt-get update -qqy \
&& apt-get install -qqy --no-install-recommends git neovim python3 python3-pip \
&& rm -rf /var/cache/apt


# USER developer
ARG NVIM_CONFIG_DIR="${XDG_CONFIG_DIR}/nvim"
WORKDIR ${NVIM_CONFIG_DIR}
RUN mkdir vendor && git clone https://github.com/folke/lazy.nvim.git vendor/lazy.nvim
COPY ./init.lua ./lua ./spell ./
RUN nvim --headless "+Lazy! sync" +qa

WORKDIR /
