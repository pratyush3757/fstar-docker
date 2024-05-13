FROM ubuntu:jammy

# Args should be after FROM statement
ARG USERNAME=docker
ARG USER_UID=1000
ARG USER_GID=$USER_UID

SHELL ["/bin/bash", "--login", "-c"]

# Parts taken from:
# https://stackoverflow.com/a/72678903
# https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user

# Install required packages and clean up
RUN apt-get update -y -q \
    && apt-get install -y -q --no-install-recommends \
    sudo \
    opam \
    git \
    ca-certificates \
    python3 \
    libgmp-dev \
    python3-distutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add a user with sudo perms
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Change to user
USER $USERNAME
WORKDIR /home/$USERNAME

# Install fstar and clean up
# `unsafe-yes` is there to prevent opam [apt-get install] prompts
RUN opam init --auto-setup --disable-sandboxing --yes \
    && eval $(opam env --switch=default) \
    && opam pin add -y --confirm-level=unsafe-yes fstar --dev-repo \
    && opam clean -a -c -s --logs

CMD ["/bin/bash", "--login"]
