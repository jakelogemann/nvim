FROM debian:unstable-slim
ENV DEBIAN="noninteractive"
RUN apt-get update -qqy \
&& apt-get install -qqy neovim \
&& rm -rf /var/cache/apt

ARG USER_NAME="developer"
ARG NVIM_CONFIG_DIR="~/.config/nvim"
RUN mkdir -p "${NVIM_CONFIG_DIR}"
COPY ./init.lua ./lua ./spell "${NVIM_CONFIG_DIR}/"
RUN cd "${NVIM_CONFIG_DIR}" && nvim --headless "+Lazy! sync" +qa
ENTRYPOINT ["nvim"]
CMD []
