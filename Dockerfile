FROM alpine

# Args should be after FROM statement
ARG USERNAME=docker
ARG USER_UID=1001 # GID 1000 already exists for some reason
ARG USER_GID=$USER_UID

# Install required packages and clean up
RUN apk update \
    && apk add \
    sudo \
    opam \
    ca-certificates \
    python3 \
    py3-setuptools \
    git \
    build-base \
    gmp-dev \
    && apk cache clean

# Add a user with sudo perms
RUN addgroup --gid $USER_GID $USERNAME \
    && adduser --disabled-password --uid $USER_UID --home "/home/$USERNAME" --ingroup "$USERNAME" $USERNAME

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

CMD ["/bin/sh"]
