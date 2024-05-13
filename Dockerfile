FROM ubuntu

# Args should be after FROM statement
ARG USERNAME=docker
ARG USER_UID=1001 # GID 1000 already exists for some reason
ARG USER_GID=$USER_UID

SHELL ["/bin/bash", "--login", "-c"]

# Parts taken from:
# https://stackoverflow.com/a/72678903
# https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user

# Install required packages and clean up
# distutils has been deprecated in favor of setuptools
RUN apt-get update -y -q \
    && apt-get install -y -q --no-install-recommends \
    sudo \
    opam \
    git \
    ca-certificates \
    python3 \
    libgmp-dev \
    python3-setuptools \
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
# add --no-depexts to remove python3-distutils dependency from z3
RUN opam init --auto-setup --disable-sandboxing --yes \
    && eval $(opam env --switch=default) \
    && opam pin add --no-depexts -y --confirm-level=unsafe-yes fstar --dev-repo \
    && opam clean -a -c -s --logs

CMD ["/bin/bash", "--login"]
