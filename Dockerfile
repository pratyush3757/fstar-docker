FROM alpine AS build

# Args should be after FROM statement
ARG USERNAME=docker
ARG USER_UID=1001 # GID 1000 already exists for some reason
ARG USER_GID=$USER_UID

# Install required packages and clean up
RUN apk update \
    && apk add \
    bash \
    opam \
    ca-certificates \
    python3 \
    py3-setuptools \
    git \
    build-base \
    gmp-dev \
    && apk cache clean

# Add a normal user
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


# Runtime image
# Installs and uses only the minimal dependencies needed to run the binaries
FROM alpine

# Args should be after FROM statement
ARG USERNAME=docker
ARG USER_UID=1001 # GID 1000 already exists for some reason
ARG USER_GID=$USER_UID

# Install required packages and clean up
RUN apk update \
    && apk add \
    build-base \
    gmp-dev \
    && apk cache clean

# Add a normal user
RUN addgroup --gid $USER_GID $USERNAME \
    && adduser --disabled-password --uid $USER_UID --home "/home/$USERNAME" --ingroup "$USERNAME" $USERNAME

# Change to user
USER $USERNAME
WORKDIR /home/$USERNAME

COPY --from=build /home/docker/.opam/default/bin/fstar.exe /home/docker/.opam/default/bin/z3 /home/docker/fstar-bin/

CMD ["/bin/ash"]
